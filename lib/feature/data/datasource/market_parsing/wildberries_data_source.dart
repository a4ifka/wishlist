import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wishlist/feature/data/datasource/market_parsing/marketplace_data_source.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/parsed_product.dart';

/// Парсер Wildberries через публичный CDN (card.json).
/// Название и изображение — из CDN. Цена недоступна (WB закрыл API PoW).
class WildberriesDataSource implements MarketplaceDataSource {
  static const _timeout = Duration(seconds: 8);

  static const _headers = {
    'User-Agent': 'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36',
  };

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

    // Ищем правильный basket параллельными запросами
    final basket = await _findBasket(vol, part, articleInt);
    if (basket == null) {
      throw Exception('Товар с артикулом $article не найден на Wildberries');
    }

    final cardUrl = 'https://basket-$basket.wbbasket.ru'
        '/vol$vol/part$part/$articleInt/info/ru/card.json';

    final response = await http
        .get(Uri.parse(cardUrl), headers: _headers)
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки данных WB: ${response.statusCode}');
    }

    final Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception('WB вернул неожиданный ответ');
    }

    final brand = (data['selling']?['brand_name'] as String?)?.trim() ?? '';
    final imt = (data['imt_name'] as String?)?.trim() ?? '';
    final name = [brand, imt].where((s) => s.isNotEmpty).join(' ');
    if (name.isEmpty) throw Exception('Не удалось получить название товара');

    final imageUrl = 'https://basket-$basket.wbbasket.ru'
        '/vol$vol/part$part/$articleInt/images/c516x688/1.webp';

    return ParsedProduct(name: name, price: 0, imageUrl: imageUrl);
  }

  /// Ищет правильный basket параллельными запросами.
  /// Пробуем estimate ± 5, берём первый 200.
  Future<String?> _findBasket(int vol, int part, int article) async {
    final est = _estimateBasket(vol);

    // Порядок пробинга: сначала estimate, потом ближайшие соседи
    final deltas = [0, 1, 2, -1, 3, 4, -2, 5, -3, 6, 7, -4];
    final futures = deltas.map((d) => _probeBasket(est + d, vol, part, article));

    // Параллельный запуск — ждём первый успешный
    final results = await Future.wait(futures);
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
          .get(Uri.parse(url), headers: _headers)
          .timeout(_timeout);
      return response.statusCode == 200 ? b : null;
    } catch (_) {
      return null;
    }
  }

  /// Грубая оценка basket по vol. Результат может быть неточным на ±5,
  /// поэтому используется только как стартовая точка для параллельного поиска.
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
    // Зона basket 19+: два участка с разным шагом
    // Участок A (basket 19..27): шаг ~226
    // Участок B (basket 28+): шаг ~335
    if (vol <= 5079) return 19 + (vol - 3054) ~/ 226;
    return 28 + (vol - 5080) ~/ 335;
  }
}
