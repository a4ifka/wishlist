import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/repositories/room_repository.dart';

class UpdateRoom implements UseCase<void, RoomParamsUpdate> {
  final RoomRepository repository;

  UpdateRoom({required this.repository});

  @override
  Future<Either<Failure, void>> call(RoomParamsUpdate params) async {
    return await repository.updateRoom(params.room);
  }
}

class RoomParamsUpdate extends Equatable {
  final RoomEntity room;

  const RoomParamsUpdate({required this.room});

  @override
  List<Object?> get props => [room];
}
