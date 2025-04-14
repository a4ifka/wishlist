import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/data/datasource/room_remote_data_source.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/entities/room_entity.dart';
import '../models/room_model.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;
  RoomRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<RoomEntity>>> getRoomsByUser() async {
    try {
      final remoteRooms = await remoteDataSource.getRoomsByUser();
      return Right(remoteRooms);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, RoomEntity>> getRoomById(String roomId) async {
    try {
      final remoteRoom = await remoteDataSource.getRoomById(roomId);
      return Right(remoteRoom);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<ServerFailure, List<Map<String, dynamic>>>> createRoom(
      RoomEntity room) async {
    RoomModel roomModel = RoomModel(
      id: room.id,
      name: room.name,
      isPublic: room.isPublic,
    );
    try {
      final createdRoom = await remoteDataSource.createRoom(roomModel);
      return Right(createdRoom);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRoom(RoomEntity room) async {
    try {
      final roomModel = RoomModel(
        id: room.id,
        name: room.name,
        isPublic: room.isPublic,
      );
      await remoteDataSource.updateRoom(roomModel);
      return const Right(null);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRoom(String roomId) async {
    try {
      await remoteDataSource.deleteRoom(roomId);
      return const Right(null);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
