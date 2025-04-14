import 'package:dartz/dartz.dart';
import 'package:wishlist/feature/data/datasource/product_remote_data_source.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';
import 'package:wishlist/feature/domain/repositories/product_repository.dart';
import 'package:wishlist/core/error/failure.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProductEntity>> getProductImage(String article) async {
    try {
      final imageUrl = await remoteDataSource.getProductImage(article);
      return Right(ProductEntity(
        article: article,
        imageUrl: imageUrl,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
