import 'package:dartz/dartz.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, AuthResponse>> signIn(String email, String password);
  Future<Either<Failure, AuthResponse>> signUp(String email, String password);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity>> getUserInfo(String uuid);
  Future<Either<Failure, void>> createUser(UserEntity userModel);
}
