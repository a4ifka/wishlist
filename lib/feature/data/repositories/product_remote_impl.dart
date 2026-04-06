import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/marketplace_type.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/marketplace_data_source.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/ozon_data_source.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/wildberries_data_source.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/yandex_market_data_source.dart';
import 'package:wishlist/feature/data/models/product_model.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';
import 'package:wishlist/feature/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final WildberriesDataSource wildberries;
  final OzonDataSource ozon;
  final YandexMarketDataSource yandexMarket;

  ProductRepositoryImpl({
    required this.wildberries,
    required this.ozon,
    required this.yandexMarket,
  });

  @override
  Future<Either<Failure, ProductEntity>> getProductByUrl(String url) async {
    try {
      final type = MarketplaceResolver.detectFromUrl(url);
      if (type == null) {
        return Left(ServerFailure(message: 'Неизвестный маркетплейс. Поддерживаются: Wildberries, Ozon, Яндекс Маркет'));
      }
      final parsed = await _sourceFor(type).parseByUrl(url);
      return Right(ProductModel.fromParsed(parsed).toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductByArticle(
      String article, MarketplaceType marketplace) async {
    try {
      final parsed = await _sourceFor(marketplace).parseByArticle(article);
      return Right(ProductModel.fromParsed(parsed).toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  MarketplaceDataSource _sourceFor(MarketplaceType type) {
    switch (type) {
      case MarketplaceType.wildberries:
        return wildberries;
      case MarketplaceType.ozon:
        return ozon;
      case MarketplaceType.yandexMarket:
        return yandexMarket;
    }
  }
}
