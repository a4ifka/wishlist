import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class UpdateWish implements UseCase<void, WishparamsUpdate> {
  final WishRepository repository;

  UpdateWish({required this.repository});

  @override
  Future<Either<Failure, void>> call(WishparamsUpdate params) async {
    return await repository.updateWish(params.wish);
  }
}

class WishparamsUpdate extends Equatable {
  final WishEntity wish;

  const WishparamsUpdate({required this.wish});

  @override
  List<Object?> get props => [wish];
}
