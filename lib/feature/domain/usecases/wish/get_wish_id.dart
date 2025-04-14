import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class GetWishById implements UseCase<WishEntity, WishparamsId> {
  final WishRepository repository;

  GetWishById({required this.repository});

  @override
  Future<Either<Failure, WishEntity>> call(WishparamsId params) async {
    return await repository.getWishById(params.wishId);
  }
}

class WishparamsId extends Equatable {
  final String wishId;

  const WishparamsId({required this.wishId});

  @override
  List<Object?> get props => [wishId];
}
