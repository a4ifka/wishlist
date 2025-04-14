import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/user_repository.dart';

class SignUpUser extends UseCase<AuthResponse, UserSignUpParams> {
  final UserRepository userRepository;

  SignUpUser({required this.userRepository});

  @override
  Future<Either<Failure, AuthResponse>> call(UserSignUpParams params) async {
    final response = await userRepository.signUp(params.email, params.password);
    return response;
  }
}

class UserSignUpParams extends Equatable {
  final String email;
  final String password;

  const UserSignUpParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
