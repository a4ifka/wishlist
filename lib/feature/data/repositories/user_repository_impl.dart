import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/data/datasource/user_remote_data_source.dart';
import 'package:wishlist/feature/data/models/user_model.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSources userRemoteDataSources;

  UserRepositoryImpl({
    required this.userRemoteDataSources,
  });

  @override
  Future<Either<Failure, AuthResponse>> signIn(
      String email, String password) async {
    try {
      final respone = await userRemoteDataSources.signInUser(email, password);
      return Right(respone);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signUp(
      String email, String password) async {
    try {
      final respone = await userRemoteDataSources.signUpUser(email, password);
      return Right(respone);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      final respone = await userRemoteDataSources.signOutUser();
      return Right(respone);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo(String uuid) async {
    try {
      final response = await userRemoteDataSources.getUserInfo(uuid);
      return Right(response);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createUser(UserEntity userEntity) async {
    final userModel = UserModel(
      id: 0,
      name: userEntity.name,
      uuid: userEntity.uuid,
    );
    try {
      final response = await userRemoteDataSources.createUser(userModel);
      return Right(response);
    } on ServerFailure catch (error) {
      return Left(ServerFailure(message: error.message));
    } catch (error) {
      return Left(ServerFailure(message: error.toString()));
    }
  }
}
