import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/user_repository.dart';

class GetUserInfo implements UseCase<UserEntity, UserParams> {
  final UserRepository repository;

  GetUserInfo({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(UserParams params) {
    final response = repository.getUserInfo(params.uuid);
    return response;
  }
}

class UserParams extends Equatable {
  final String uuid;

  const UserParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
