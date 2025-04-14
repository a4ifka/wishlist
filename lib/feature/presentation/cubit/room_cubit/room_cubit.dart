import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';

import 'package:wishlist/feature/domain/usecases/room/create_room.dart';
import 'package:wishlist/feature/domain/usecases/room/delete_room.dart';
import 'package:wishlist/feature/domain/usecases/room/get_room_id.dart';
import 'package:wishlist/feature/domain/usecases/room/get_room_user.dart';
import 'package:wishlist/feature/domain/usecases/room/update_room.dart';

part 'room_state.dart';

class RoomCubit extends Cubit<RoomState> {
  final GetRoomsByUser getRoomsByUser;
  final GetRoomById getRoomById;
  final CreateRoom createRoom;
  final UpdateRoom updateRoom;
  final DeleteRoom deleteRoom;

  RoomCubit({
    required this.getRoomsByUser,
    required this.getRoomById,
    required this.createRoom,
    required this.updateRoom,
    required this.deleteRoom,
  }) : super(RoomInitial());

  fetchRoomsByUser() async {
    emit(RoomStart());
    final failureOrUser = await getRoomsByUser('');
    emit(failureOrUser.fold(
        (failure) => RoomError(message: mapFailureFromMessage(failure)),
        (rooms) => RoomsLoaded(rooms: rooms)));
  }

  // Future<void> fetchRoomById(RoomParamsId params) async {
  //   emit(RoomLoading());
  //   final result = await getRoomById(params);
  //   result.fold(
  //     (failure) => emit(RoomError(message: mapFailureFromMessage(failure))),
  //     (room) => emit(RoomLoaded(room: room)),
  //   );
  // }

  addRoom(RoomEntity roomEntity) async {
    emit(RoomStart());
    final failureOrRoom = await createRoom(RoomParamsCreate(room: roomEntity));
    emit(failureOrRoom.fold(
        (failure) => RoomError(message: mapFailureFromMessage(failure)),
        (room) => RoomLoaded(room: room)));
  }

  // Future<void> editRoom(RoomParamsUpdate params) async {
  //   emit(RoomOperationInProgress());
  //   final result = await updateRoom(params);
  //   result.fold(
  //     (failure) => emit(RoomError(message: mapFailureFromMessage(failure))),
  //     (_) {
  //       emit(RoomOperationSuccess());
  //       if (state is RoomsLoaded) {
  //         final currentRooms = (state as RoomsLoaded).rooms;
  //         final updatedRooms = currentRooms
  //             .map((r) => r.id == params.room ? params.room : r)
  //             .toList();
  //         emit(RoomsLoaded(rooms: updatedRooms));
  //       }
  //     },
  //   );
  // }

  // Future<void> removeRoom(RoomParamsDelete params) async {
  //   emit(RoomOperationInProgress());
  //   final result = await deleteRoom(params);
  //   result.fold(
  //     (failure) => emit(RoomError(message: mapFailureFromMessage(failure))),
  //     (_) {
  //       emit(RoomOperationSuccess());
  //       if (state is RoomsLoaded) {
  //         final currentRooms = (state as RoomsLoaded).rooms;
  //         emit(RoomsLoaded(
  //             rooms:
  //                 currentRooms.where((r) => r.id != params.roomId).toList()));
  //       }
  //     },
  //   );
  // }

  String mapFailureFromMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return "ServerFailure";
      default:
        return "Unexpected error";
    }
  }
}
