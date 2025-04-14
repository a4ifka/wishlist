import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/user_repository.dart';

class CreateUser implements UseCase<void, UserParamsCreate> {
  final UserRepository repository;

  CreateUser({required this.repository});

  @override
  Future<Either<Failure, void>> call(UserParamsCreate params) {
    final response = repository.createUser(params.userModel);
    return response;
  }
}

class UserParamsCreate extends Equatable {
  final UserEntity userModel;

  const UserParamsCreate({required this.userModel});

  @override
  List<Object?> get props => [userModel];
}
