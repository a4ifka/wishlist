import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/marketplace_type.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';

abstract class ProductRepository {
  /// Парсит товар по полной ссылке. Маркетплейс определяется автоматически.
  Future<Either<Failure, ProductEntity>> getProductByUrl(String url);

  /// Парсит товар по артикулу. Поддерживается только Wildberries.
  Future<Either<Failure, ProductEntity>> getProductByArticle(
      String article, MarketplaceType marketplace);
}
