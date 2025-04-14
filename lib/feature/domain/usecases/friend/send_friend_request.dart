import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';

import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class SendFriendRequest extends UseCase<void, SendFriendRequestParams> {
  final FriendRepository repository;

  SendFriendRequest({required this.repository});
  @override
  Future<Either<Failure, void>> call(SendFriendRequestParams params) {
    final response =
        repository.sendFriendRequest(params.senderId, params.receiverId);
    return response;
  }
}

class SendFriendRequestParams extends Equatable {
  final String senderId;
  final String receiverId;

  const SendFriendRequestParams({
    required this.senderId,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [senderId, receiverId];
}
