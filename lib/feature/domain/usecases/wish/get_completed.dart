import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class GetCompleted implements UseCase<int, WishParamsGetCompleted> {
  final WishRepository repository;

  GetCompleted({required this.repository});

  @override
  Future<Either<Failure, int>> call(WishParamsGetCompleted params) async {
    return await repository.getCompleted();
  }
}

// ignore: must_be_immutable
class WishParamsGetCompleted extends Equatable {
  int i;
  WishParamsGetCompleted({required this.i});

  @override
  List<Object?> get props => [
        i,
      ];
}
