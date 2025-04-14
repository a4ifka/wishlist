part of 'room_cubit.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

class RoomInitial extends RoomState {}

class RoomStart extends RoomState {}

class RoomLoading extends RoomState {}

class RoomsLoaded extends RoomState {
  final List<RoomEntity> rooms;

  const RoomsLoaded({required this.rooms});

  @override
  List<Object> get props => [rooms];
}

class RoomLoaded extends RoomState {
  final List<Map<String, dynamic>> room;

  const RoomLoaded({required this.room});

  @override
  List<Object> get props => [room];
}

class RoomOperationInProgress extends RoomState {}

class RoomOperationSuccess extends RoomState {}

class RoomError extends RoomState {
  final String message;

  const RoomError({required this.message});

  @override
  List<Object> get props => [message];
}
