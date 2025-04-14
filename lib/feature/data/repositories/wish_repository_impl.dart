import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/data/datasource/wish_remote_data_source.dart';
import '../../domain/repositories/wish_repository.dart';
import '../../domain/entities/wish_entity.dart';
import '../models/wish_model.dart';

class WishRepositoryImpl implements WishRepository {
  final WishRemoteDataSource remoteDataSource;

  WishRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<WishEntity>>> getWishesByRoom(int roomId) async {
    try {
      final remoteWishes = await remoteDataSource.getWishesByRoom(roomId);
      return Right(remoteWishes);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, WishEntity>> getWishById(String wishId) async {
    try {
      final remoteWish = await remoteDataSource.getWishById(wishId);
      return Right(remoteWish);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, List<Map<String, dynamic>>>> createWish(
      WishEntity wish) async {
    final wishModel = WishModel(
      id: wish.id,
      roomId: wish.roomId,
      name: wish.name,
      url: wish.url,
      price: wish.price,
      imageUrl: wish.imageUrl,
      isFulfilled: wish.isFulfilled,
      fulfilledBy: wish.fulfilledBy,
    );
    try {
      final createdWish = await remoteDataSource.createWish(wishModel);
      return Right(createdWish);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateWish(WishEntity wish) async {
    try {
      final wishModel = WishModel(
        id: wish.id,
        roomId: wish.roomId,
        name: wish.name,
        url: wish.url,
        price: wish.price,
        imageUrl: wish.imageUrl,
        isFulfilled: wish.isFulfilled,
        fulfilledBy: wish.fulfilledBy,
      );
      await remoteDataSource.updateWish(wishModel);
      return const Right(null);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteWish(String wishId) async {
    try {
      await remoteDataSource.deleteWish(wishId);
      return const Right(null);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> fulfillWish(
      String wishId, String userId) async {
    try {
      await remoteDataSource.fulfillWish(wishId, userId);
      return const Right(null);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
