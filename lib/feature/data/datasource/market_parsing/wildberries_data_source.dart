import 'dart:async';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:wishlist/feature/data/datasource/market_parsing/marketplace_data_source.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/parsed_product.dart';

/// Парсер Wildberries.
///
/// Стратегия:
/// 1. HeadlessInAppWebView загружает wildberries.ru, проходит antibot PoW,
///    мы забираем cookies и сразу уничтожаем WebView.
/// 2. Все последующие запросы — обычный http.get с сохранёнными cookies.
/// 3. При 498/403 (cookies протухли) — однократный WebView retry.
/// 4. Fallback при любой ошибке — basket CDN card.json (без цены).
class WildberriesDataSource implements MarketplaceDataSource {
  static const _internalApi =
      'https://www.wildberries.ru/__internal/u-card/cards/v4/detail'
      '?appType=1&curr=rub&dest=1259570991&spp=30'
      '&hide_vflags=4294967296&ab_testing=false&lang=ru';

  static const _userAgent =
      'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36';

  static const _httpTimeout = Duration(seconds: 10);
  static const _webViewTimeout = Duration(seconds: 30);

  String? _cookieHeader;
  Future<String>? _cookiesFuture;

  // ─── Public API ───────────────────────────────────────────────────────────

  @override
  Future<ParsedProduct> parseByUrl(String url) async {
    final article = MarketplaceResolver.extractWbArticle(url);
    if (article == null) {
      throw Exception('Не удалось извлечь артикул из ссылки Wildberries');
    }
    return parseByArticle(article);
  }

  @override
  Future<ParsedProduct> parseByArticle(String article) async {
    final articleInt = int.tryParse(article);
    if (articleInt == null || articleInt <= 0) {
      throw Exception('Некорректный артикул: $article');
    }

    final vol = articleInt ~/ 100000;
    final part = articleInt ~/ 1000;
    final results = await Future.wait([
      _fetchProductData(article),
      _findBasket(vol, part, articleInt),
    ]);

    final data = results[0] as Map<String, dynamic>?;
    final basket = results[1] as String?;

    final imageUrl = basket != null
        ? 'https://basket-$basket.wbbasket.ru'
            '/vol$vol/part$part/$articleInt/images/c516x688/1.webp'
        : null;

    if (data != null) {
      final parsed = _parseProduct(data, articleInt, imageUrl);
      if (parsed != null) return parsed;
    }

    // Fallback: card.json из basket CDN (без цены)
    if (basket == null) {
      throw Exception('Товар $article не найден на Wildberries');
    }
    return _parseFromCardJson(vol, part, articleInt, basket, imageUrl);
  }

  // ─── Cookie management ────────────────────────────────────────────────────

  Future<String> _ensureCookies() async {
    if (_cookieHeader != null) return _cookieHeader!;

    // Все параллельные вызовы ждут один и тот же Future
    _cookiesFuture ??= _fetchCookiesViaWebView();
    try {
      final cookies = await _cookiesFuture!;
      _cookieHeader = cookies;
      return cookies;
    } catch (e) {
      _cookiesFuture = null;
      rethrow;
    }
  }

  void _invalidateCookies() {
    _cookieHeader = null;
    _cookiesFuture = null;
  }

  /// Запускает HeadlessInAppWebView, ждёт решения antibot,
  /// забирает cookies и сразу уничтожает WebView.
  Future<String> _fetchCookiesViaWebView() async {
    final completer = Completer<String>();
    HeadlessInAppWebView? webView;

    webView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri('https://www.wildberries.ru/'),
      ),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        userAgent: _userAgent,
      ),
      onLoadStop: (controller, url) async {
        if (completer.isCompleted) return;

        final title = await controller.getTitle() ?? '';
        if (title == 'Почти готово...') return; // antibot ещё работает

        final cookies = await CookieManager.instance().getCookies(
          url: WebUri('https://www.wildberries.ru/'),
        );
        final header =
            cookies.map((c) => '${c.name}=${c.value}').join('; ');

        completer.complete(header);
        // dispose вне колбэка, чтобы не разрушать WebView изнутри него
        Future.microtask(() => webView?.dispose());
      },
    );

    await webView.run();

    try {
      return await completer.future.timeout(_webViewTimeout);
    } on TimeoutException {
      await webView.dispose();
      throw Exception(
          'WB antibot не решился за ${_webViewTimeout.inSeconds}с');
    }
  }

  // ─── HTTP запрос ──────────────────────────────────────────────────────────

  Future<Map<String, dynamic>?> _fetchProductData(String article) async {
    try {
      final cookies = await _ensureCookies();
      var response = await _doRequest(article, cookies);

      // Cookies протухли — обновляем и делаем ещё одну попытку
      if (response.statusCode == 498 || response.statusCode == 403) {
        _invalidateCookies();
        final freshCookies = await _ensureCookies();
        response = await _doRequest(article, freshCookies);
      }

      if (response.statusCode != 200) return null;
      return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<http.Response> _doRequest(String article, String cookies) {
    return http.get(
      Uri.parse('$_internalApi&nm=$article'),
      headers: {
        'User-Agent': _userAgent,
        'Cookie': cookies,
        'Accept': 'application/json',
        'Referer': 'https://www.wildberries.ru/',
      },
    ).timeout(_httpTimeout);
  }


  ParsedProduct? _parseProduct(
    Map<String, dynamic> data,
    int articleInt,
    String? imageUrl,
  ) {
    final products = data['products'] as List?;
    if (products == null || products.isEmpty) return null;

    Map<String, dynamic>? product;
    for (final p in products) {
      final map = p as Map<String, dynamic>;
      if (map['id'] == articleInt) {
        product = map;
        break;
      }
    }
    product ??= products.first as Map<String, dynamic>;

    final brand = (product['brand'] as String?)?.trim() ?? '';
    final imt = (product['name'] as String?)?.trim() ?? '';
    final name = [brand, imt].where((s) => s.isNotEmpty).join(' ');
    if (name.isEmpty) return null;

    double price = 0;
    final sizes = product['sizes'] as List?;
    if (sizes != null) {
      for (final size in sizes) {
        final priceMap = (size as Map<String, dynamic>)['price'];
        if (priceMap is Map) {
          final productPrice = priceMap['product'] as int?;
          if (productPrice != null && productPrice > 0) {
            price = productPrice / 100.0;
            break;
          }
        }
      }
    }

    return ParsedProduct(name: name, price: price, imageUrl: imageUrl);
  }


  Future<ParsedProduct> _parseFromCardJson(
    int vol,
    int part,
    int articleInt,
    String basket,
    String? imageUrl,
  ) async {
    final url = 'https://basket-$basket.wbbasket.ru'
        '/vol$vol/part$part/$articleInt/info/ru/card.json';
    final response = await http
        .get(Uri.parse(url), headers: {'User-Agent': _userAgent})
        .timeout(_httpTimeout);
    if (response.statusCode != 200) {
      throw Exception('Ошибка card.json: ${response.statusCode}');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    final brand =
        (data['selling']?['brand_name'] as String?)?.trim() ?? '';
    final imt = (data['imt_name'] as String?)?.trim() ?? '';
    final name = [brand, imt].where((s) => s.isNotEmpty).join(' ');
    if (name.isEmpty) throw Exception('Не удалось получить название товара');
    return ParsedProduct(name: name, price: 0, imageUrl: imageUrl);
  }

  Future<String?> _findBasket(int vol, int part, int article) async {
    final est = _estimateBasket(vol);
    final deltas = [0, 1, 2, -1, 3, 4, -2, 5, -3, 6, 7, -4];
    final results = await Future.wait(
        deltas.map((d) => _probeBasket(est + d, vol, part, article)));
    for (final r in results) {
      if (r != null) return r;
    }
    return null;
  }

  Future<String?> _probeBasket(int n, int vol, int part, int article) async {
    if (n < 1 || n > 60) return null;
    final b = n.toString().padLeft(2, '0');
    final url = 'https://basket-$b.wbbasket.ru'
        '/vol$vol/part$part/$article/info/ru/card.json';
    try {
      final response = await http
          .get(Uri.parse(url), headers: {'User-Agent': _userAgent})
          .timeout(_httpTimeout);
      return response.statusCode == 200 ? b : null;
    } catch (_) {
      return null;
    }
  }

  int _estimateBasket(int vol) {
    if (vol <= 143) return 1;
    if (vol <= 287) return 2;
    if (vol <= 431) return 3;
    if (vol <= 719) return 4;
    if (vol <= 1007) return 5;
    if (vol <= 1061) return 6;
    if (vol <= 1115) return 7;
    if (vol <= 1169) return 8;
    if (vol <= 1313) return 9;
    if (vol <= 1601) return 10;
    if (vol <= 1655) return 11;
    if (vol <= 1919) return 12;
    if (vol <= 2045) return 13;
    if (vol <= 2189) return 14;
    if (vol <= 2405) return 15;
    if (vol <= 2621) return 16;
    if (vol <= 2837) return 17;
    if (vol <= 3053) return 18;
    if (vol <= 5079) return 19 + (vol - 3054) ~/ 226;
    return 28 + (vol - 5080) ~/ 335;
  }
}
