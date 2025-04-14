import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class RespondToFriendRequest
    extends UseCase<void, RespondToFriendRequestParams> {
  final FriendRepository repository;

  RespondToFriendRequest({required this.repository});
  @override
  Future<Either<Failure, void>> call(RespondToFriendRequestParams params) {
    final response =
        repository.respondToFriendRequest(params.requestId, params.accept);
    return response;
  }
}

class RespondToFriendRequestParams extends Equatable {
  final String requestId;
  final bool accept;

  const RespondToFriendRequestParams({
    required this.requestId,
    required this.accept,
  });

  @override
  List<Object?> get props => [requestId, accept];
}
