import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';

import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';

class GetFriendRooms extends UseCase<List<RoomEntity>, GetFriendRoomsParams> {
  final FriendRepository repository;

  GetFriendRooms({required this.repository});
  @override
  Future<Either<Failure, List<RoomEntity>>> call(GetFriendRoomsParams params) {
    final response = repository.getRoomsFriend(params.uuid);
    return response;
  }
}

class GetFriendRoomsParams extends Equatable {
  final String uuid;

  const GetFriendRoomsParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}
