import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/friend_entity.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';

abstract class FriendRepository {
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
  Future<Either<Failure, String>> sendFriendRequest(
      String senderId, String receiverId);
  Future<Either<Failure, List<FriendEntity>>> getFriendRequests(String userId);
  Future<Either<Failure, void>> respondToFriendRequest(
      String requestId, bool accept);
  Future<Either<Failure, List<UserEntity>>> getFriends(String userId);
  Future<Either<Failure, void>> removeFriend(String userId, String friendId);
  Future<Either<Failure, List<UserEntity>>> loadFriends(String userId);
  Future<Either<Failure, List<RoomEntity>>> getRoomsFriend(String uuid);
}
