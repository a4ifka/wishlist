import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class FulfillWish implements UseCase<void, WishparamsFulfill> {
  final WishRepository repository;

  FulfillWish({required this.repository});

  @override
  Future<Either<Failure, void>> call(WishparamsFulfill params) async {
    return await repository.fulfillWish(params.wishId, params.userId);
  }
}

// ignore: must_be_immutable
class WishparamsFulfill extends Equatable {
  int wishId;
  String userId;

  WishparamsFulfill({required this.wishId, required this.userId});

  @override
  List<Object?> get props => [wishId, userId];
}
