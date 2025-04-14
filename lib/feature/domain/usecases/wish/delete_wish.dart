import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class DeleteWish implements UseCase<void, WishparamsDelete> {
  final WishRepository repository;

  DeleteWish({required this.repository});

  @override
  Future<Either<Failure, void>> call(WishparamsDelete params) async {
    return await repository.deleteWish(params.wishId);
  }
}

class WishparamsDelete extends Equatable {
  final String wishId;

  const WishparamsDelete({required this.wishId});

  @override
  List<Object?> get props => [wishId];
}
