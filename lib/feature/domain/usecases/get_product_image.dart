import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';
import 'package:wishlist/feature/domain/repositories/product_repository.dart';

class GetProductImage implements UseCase<ProductEntity, String> {
  final ProductRepository repository;

  GetProductImage(this.repository);

  @override
  Future<Either<Failure, ProductEntity>> call(String article) async {
    return await repository.getProductImage(article);
  }
}
