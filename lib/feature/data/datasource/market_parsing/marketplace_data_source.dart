import 'package:wishlist/core/marketplace_type.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/parsed_product.dart';

abstract class MarketplaceDataSource {
  Future<ParsedProduct> parseByUrl(String url);
  Future<ParsedProduct> parseByArticle(String article);
}

class MarketplaceResolver {
  /// Определяет маркетплейс по URL. Возвращает null если не распознан.
  static MarketplaceType? detectFromUrl(String url) {
    if (url.contains('wildberries.ru') || url.contains('wb.ru')) {
      return MarketplaceType.wildberries;
    }
    if (url.contains('ozon.ru')) return MarketplaceType.ozon;
    if (url.contains('market.yandex.ru')) return MarketplaceType.yandexMarket;
    return null;
  }

  /// Извлекает артикул из URL Wildberries.
  /// Пример: https://www.wildberries.ru/catalog/12345678/detail.aspx → "12345678"
  static String? extractWbArticle(String url) {
    final match = RegExp(r'/catalog/(\d+)').firstMatch(url);
    return match?.group(1);
  }
}
