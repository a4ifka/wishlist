import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';

import '../entities/room_entity.dart';

abstract class RoomRepository {
  Future<Either<Failure, List<RoomEntity>>> getRoomsByUser();
  Future<Either<Failure, RoomEntity>> getRoomById(String roomId);
  Future<Either<Failure, List<Map<String, dynamic>>>> createRoom(
      RoomEntity room);
  Future<Either<Failure, void>> updateRoom(RoomEntity room);
  Future<Either<Failure, void>> deleteRoom(String roomId);
}
