import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class GetMyBooking implements UseCase<int, WishParamsGetMyBooking> {
  final WishRepository repository;

  GetMyBooking({required this.repository});

  @override
  Future<Either<Failure, int>> call(WishParamsGetMyBooking params) async {
    return await repository.getMyBooking();
  }
}

// ignore: must_be_immutable
class WishParamsGetMyBooking extends Equatable {
  int i;
  WishParamsGetMyBooking({required this.i});

  @override
  List<Object?> get props => [
        i,
      ];
}
