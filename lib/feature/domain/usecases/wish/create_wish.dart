import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class CreateWish
    implements UseCase<List<Map<String, dynamic>>, WishparamsCreate> {
  final WishRepository repository;

  CreateWish({required this.repository});

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      WishparamsCreate params) {
    final response = repository.createWish(params.wish);
    return response;
  }
}

class WishparamsCreate extends Equatable {
  final WishEntity wish;

  const WishparamsCreate({required this.wish});

  @override
  List<Object?> get props => [wish];
}
