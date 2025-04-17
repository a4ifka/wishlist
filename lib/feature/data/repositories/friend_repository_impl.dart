import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/data/datasource/friend_remote_data_source.dart';
import 'package:wishlist/feature/domain/entities/friend_entity.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class FriendRepositoryImpl extends FriendRepository {
  final FriendRemoteDataSource friendRemoteDataSource;

  FriendRepositoryImpl({required this.friendRemoteDataSource});

  @override
  Future<Either<Failure, List<FriendEntity>>> getFriendRequests(
      String userId) async {
    try {
      final remoteFriends =
          await friendRemoteDataSource.getFriendRequests(userId);
      return Right(remoteFriends);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getFriends(String userId) async {
    try {
      final remoteFriends = await friendRemoteDataSource.getFriends(userId);
      return Right(remoteFriends);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> respondToFriendRequest(
      String requestId, bool accept) async {
    try {
      final remoteFriends = await friendRemoteDataSource.respondToFriendRequest(
          requestId, accept);
      return Right(remoteFriends);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    try {
      final remoteFriends = await friendRemoteDataSource.searchUsers(query);
      return Right(remoteFriends);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendFriendRequest(
      String senderId, String receiverId) async {
    try {
      final remoteFriends =
          await friendRemoteDataSource.sendFriendRequest(senderId, receiverId);
      return Right(remoteFriends);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFriend(
      String userId, String friendId) async {
    try {
      final remoteFriends =
          await friendRemoteDataSource.removeFriend(userId, friendId);
      return Right(remoteFriends);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> loadFriends(String userId) async {
    try {
      final remoteFriends = await friendRemoteDataSource.loadFriends(userId);
      return Right(remoteFriends);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoomEntity>>> getRoomsFriend(String uuid) async {
    try {
      final remoteRooms = await friendRemoteDataSource.getRoomsFriend(uuid);
      return Right(remoteRooms);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
