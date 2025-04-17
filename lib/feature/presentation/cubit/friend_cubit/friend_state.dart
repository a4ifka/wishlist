import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/domain/entities/friend_entity.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';

abstract class FriendState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FriendInitial extends FriendState {}

class FriendStart extends FriendState {}

// Состояния для поиска
class FriendSearchLoading extends FriendState {}

class FriendRoomsSuccess extends FriendState {
  final List<RoomEntity> room;
  FriendRoomsSuccess(this.room);
  @override
  List<Object?> get props => [room];
}

class FriendListSuccess extends FriendState {
  final List<UserEntity> users;
  FriendListSuccess(this.users);
  @override
  List<Object?> get props => [users];
}

class FriendSearchSuccess extends FriendState {
  final List<UserEntity> users;
  FriendSearchSuccess(this.users);
  @override
  List<Object?> get props => [users];
}

class FriendSearchError extends FriendState {
  final String message;
  FriendSearchError(this.message);
  @override
  List<Object?> get props => [message];
}

// Состояния для запросов
class FriendRequestsLoading extends FriendState {}

class FriendRequestsLoaded extends FriendState {
  final List<FriendEntity> requests;
  FriendRequestsLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class FriendRequestsError extends FriendState {
  final String message;
  FriendRequestsError(this.message);
  @override
  List<Object?> get props => [message];
}

// Состояния для списка друзей
class FriendListLoading extends FriendState {}

class FriendListLoaded extends FriendState {
  final List<UserEntity> friend;
  FriendListLoaded(this.friend);
  @override
  List<Object?> get props => [friend];
}

class FriendListError extends FriendState {
  final String message;
  FriendListError(this.message);
  @override
  List<Object?> get props => [message];
}

// Общие состояния для действий
class FriendActionLoading extends FriendState {}

class FriendActionSuccess extends FriendState {
  final String message;
  FriendActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class FriendActionError extends FriendState {
  final String message;
  FriendActionError(this.message);
  @override
  List<Object?> get props => [message];
}

class FriendError extends FriendState {
  final String message;

  FriendError({required this.message});

  @override
  List<Object> get props => [message];
}
