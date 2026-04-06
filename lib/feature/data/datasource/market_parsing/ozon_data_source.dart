import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:wishlist/feature/data/datasource/market_parsing/marketplace_data_source.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/parsed_product.dart';

class OzonDataSource implements MarketplaceDataSource {
  static const _timeout = Duration(seconds: 12);

  static const _headers = {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
    'Accept-Language': 'ru-RU,ru;q=0.9',
    'Accept': 'text/html,application/xhtml+xml',
  };

  @override
  Future<ParsedProduct> parseByUrl(String url) async {
    final http.Response response;
    try {
      response =
          await http.get(Uri.parse(url), headers: _headers).timeout(_timeout);
    } catch (_) {
      throw Exception('Нет ответа от Ozon — проверьте соединение');
    }

    if (response.statusCode == 403 || response.statusCode == 429) {
      throw Exception(
        'Ozon заблокировал запрос (${response.statusCode}). '
        'Попробуйте ввести данные вручную.',
      );
    }
    if (response.statusCode != 200) {
      throw Exception('Ozon вернул ошибку ${response.statusCode}');
    }

    final doc = html_parser.parse(response.body);

    final name = doc
            .querySelector('meta[property="og:title"]')
            ?.attributes['content']
            ?.trim() ??
        '';

    // Если OG-тег не найден — скорее всего страница заблокирована
    if (name.isEmpty) {
      throw Exception(
        'Ozon не вернул данные о товаре. '
        'Попробуйте скопировать название и цену вручную.',
      );
    }

    final imageUrl =
        doc.querySelector('meta[property="og:image"]')?.attributes['content'];

    double price = 0;
    final rawPrice = doc
        .querySelector('meta[property="og:price:amount"]')
        ?.attributes['content'];
    if (rawPrice != null) {
      price = double.tryParse(rawPrice.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
    }

    return ParsedProduct(
      name: _cleanName(name),
      price: price,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<ParsedProduct> parseByArticle(String article) async {
    throw Exception('Для Ozon введите полную ссылку на товар');
  }

  String _cleanName(String name) {
    return name
        .replaceAll(RegExp(r'\s*[–—-]\s*купить.*', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s*в интернет.*', caseSensitive: false), '')
        .trim();
  }
}
