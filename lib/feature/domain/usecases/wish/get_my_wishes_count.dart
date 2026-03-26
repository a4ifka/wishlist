import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class GetMyWishesCount implements UseCase<int, NoWishParams> {
  final WishRepository repository;

  GetMyWishesCount({required this.repository});

  @override
  Future<Either<Failure, int>> call(NoWishParams params) async {
    return await repository.getMyWishesCount();
  }
}

class NoWishParams extends Equatable {
  const NoWishParams();

  @override
  List<Object?> get props => [];
}
