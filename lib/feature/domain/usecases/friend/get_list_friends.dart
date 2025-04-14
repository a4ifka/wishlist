import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';

import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class GetListFriends extends UseCase<List<UserEntity>, GetListFriendsParams> {
  final FriendRepository repository;

  GetListFriends({required this.repository});
  @override
  Future<Either<Failure, List<UserEntity>>> call(GetListFriendsParams params) {
    final response = repository.loadFriends(params.userId);
    return response;
  }
}

class GetListFriendsParams extends Equatable {
  final String userId;

  const GetListFriendsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
