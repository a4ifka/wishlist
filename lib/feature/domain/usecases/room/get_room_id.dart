import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/repositories/room_repository.dart';

class GetRoomById implements UseCase<RoomEntity, RoomParamsId> {
  final RoomRepository repository;

  GetRoomById({required this.repository});

  @override
  Future<Either<Failure, RoomEntity>> call(RoomParamsId params) async {
    return await repository.getRoomById(params.roomId);
  }
}

class RoomParamsId extends Equatable {
  final String roomId;

  const RoomParamsId({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}
