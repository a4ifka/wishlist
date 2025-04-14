import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class SeatchUsers extends UseCase<List<UserEntity>, SeatchUsersParams> {
  final FriendRepository repository;

  SeatchUsers({required this.repository});
  @override
  Future<Either<Failure, List<UserEntity>>> call(
      SeatchUsersParams params) async {
    final response = await repository.searchUsers(params.query);
    return response;
  }
}

class SeatchUsersParams extends Equatable {
  final String query;

  const SeatchUsersParams({
    required this.query,
  });

  @override
  List<Object?> get props => [query];
}
