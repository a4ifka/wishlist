import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/repositories/room_repository.dart';

class CreateRoom
    implements UseCase<List<Map<String, dynamic>>, RoomParamsCreate> {
  final RoomRepository repository;

  CreateRoom({required this.repository});

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      RoomParamsCreate params) {
    final response = repository.createRoom(params.room);
    return response;
  }
}

class RoomParamsCreate extends Equatable {
  final RoomEntity room;

  const RoomParamsCreate({required this.room});

  @override
  List<Object?> get props => [room];
}
