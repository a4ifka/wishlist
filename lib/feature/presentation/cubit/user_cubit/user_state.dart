import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];

  get dynamicText => null;
}

class UserInitial extends UserState {}

class UserStart extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity users;

  const UserLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserCreated extends UserState {}

class UserOperationInProgress extends UserState {}

class UserOperationSuccess extends UserState {}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}
