import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class GetFriends extends UseCase<List<UserEntity>, FriendGetParams> {
  final FriendRepository repository;

  GetFriends({required this.repository});
  @override
  Future<Either<Failure, List<UserEntity>>> call(FriendGetParams params) {
    final response = repository.getFriends(params.userId);
    return response;
  }
}

class FriendGetParams extends Equatable {
  final String userId;

  const FriendGetParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
