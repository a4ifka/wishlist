import '../entities/wish_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';

abstract class WishRepository {
  Future<Either<Failure, List<WishEntity>>> getWishesByRoom(int roomId);
  Future<Either<Failure, WishEntity>> getWishById(String wishId);
  Future<Either<ServerFailure, List<Map<String, dynamic>>>> createWish(
      WishEntity wish);
  Future<Either<Failure, void>> updateWish(WishEntity wish);
  Future<Either<Failure, void>> deleteWish(String wishId);
  Future<Either<Failure, void>> fulfillWish(String wishId, String userId);
}
