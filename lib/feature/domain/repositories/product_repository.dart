import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductEntity>> getProductImage(String article);
}
