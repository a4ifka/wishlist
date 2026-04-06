import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/marketplace_type.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';
import 'package:wishlist/feature/domain/repositories/product_repository.dart';

class GetProduct implements UseCase<ProductEntity, GetProductParams> {
  final ProductRepository repository;

  GetProduct({required this.repository});

  @override
  Future<Either<Failure, ProductEntity>> call(GetProductParams params) {
    if (params.marketplace != null) {
      return repository.getProductByArticle(params.input, params.marketplace!);
    }
    return repository.getProductByUrl(params.input);
  }
}

class GetProductParams extends Equatable {
  /// Полная ссылка на товар или артикул (если указан marketplace).
  final String input;

  /// Указывается только когда input — артикул, а не URL.
  final MarketplaceType? marketplace;

  const GetProductParams({required this.input, this.marketplace});

  @override
  List<Object?> get props => [input, marketplace];
}
