import 'package:dartz/dartz.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/repositories/room_repository.dart';

class GetRoomsByUser implements UseCase<List<RoomEntity>, String> {
  final RoomRepository repository;

  GetRoomsByUser({required this.repository});

  @override
  Future<Either<Failure, List<RoomEntity>>> call(String str) async {
    final response = await repository.getRoomsByUser();
    return response;
  }
}
