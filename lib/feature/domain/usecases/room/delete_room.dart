import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/room_repository.dart';

class DeleteRoom implements UseCase<void, RoomParamsDelete> {
  final RoomRepository repository;

  DeleteRoom({required this.repository});

  @override
  Future<Either<Failure, void>> call(RoomParamsDelete params) async {
    return await repository.deleteRoom(params.roomId);
  }
}

class RoomParamsDelete extends Equatable {
  final String roomId;

  const RoomParamsDelete({required this.roomId});

  @override
  List<Object?> get props => [roomId];
}
