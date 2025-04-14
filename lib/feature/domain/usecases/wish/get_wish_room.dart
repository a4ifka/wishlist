import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class GetWishesByRoom implements UseCase<List<WishEntity>, WishparamsRoom> {
  final WishRepository repository;

  GetWishesByRoom({required this.repository});

  @override
  Future<Either<Failure, List<WishEntity>>> call(WishparamsRoom params) {
    final response = repository.getWishesByRoom(params.roomId);
    return response;
  }
}

class WishparamsRoom extends Equatable {
  final int roomId;

  const WishparamsRoom({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}
