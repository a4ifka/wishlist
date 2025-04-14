import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/friend_entity.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class GetFriendRequests
    extends UseCase<List<FriendEntity>, FriendGetRequestParams> {
  final FriendRepository repository;

  GetFriendRequests({required this.repository});
  @override
  Future<Either<Failure, List<FriendEntity>>> call(
      FriendGetRequestParams params) {
    final response = repository.getFriendRequests(params.userId);
    return response;
  }
}

class FriendGetRequestParams extends Equatable {
  final String userId;

  const FriendGetRequestParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
