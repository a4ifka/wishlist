import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SignUpUserState extends Equatable {
  const SignUpUserState();

  @override
  List<Object?> get props => [];
}

class SignUpUserInitial extends SignUpUserState {}

class SignUpUserStart extends SignUpUserState {}

class SignUpUserLoaded extends SignUpUserState {
  final AuthResponse user;

  const SignUpUserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignUpUserError extends SignUpUserState {
  final String message;

  const SignUpUserError({required this.message});

  @override
  List<Object?> get props => [message];
}
