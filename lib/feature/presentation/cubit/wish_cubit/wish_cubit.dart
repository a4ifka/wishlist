import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/domain/usecases/wish/create_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/delete_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/fulill_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/get_wish_id.dart';
import 'package:wishlist/feature/domain/usecases/wish/get_wish_room.dart';
import 'package:wishlist/feature/domain/usecases/wish/update_wish.dart';

part 'wish_state.dart';

class WishCubit extends Cubit<WishState> {
  final GetWishesByRoom getWishesByRoom;
  final GetWishById getWishById;
  final CreateWish createWish;
  final UpdateWish updateWish;
  final DeleteWish deleteWish;
  final FulfillWish fulfillWish;

  WishCubit({
    required this.getWishesByRoom,
    required this.getWishById,
    required this.createWish,
    required this.updateWish,
    required this.deleteWish,
    required this.fulfillWish,
  }) : super(WishInitial());

  fetchWishesByRoom(int roomId) async {
    emit(WishStart());
    final failureOrUser = await getWishesByRoom(WishparamsRoom(roomId: roomId));
    emit(failureOrUser.fold(
      (failure) => WishError(message: mapFailureFromMessage(failure)),
      (wishes) => WishesLoaded(wishes: wishes),
    ));
  }

  // Future<void> loadWishById(WishparamsId params) async {
  //   emit(WishLoading());
  //   final result = await getWishById(params);
  //   result.fold(
  //     (failure) => emit(WishError(message: mapFailureFromMessage(failure))),
  //     (wish) => emit(WishLoaded(wish: wish)),
  //   );
  // }

  addWish(WishEntity wishEntity) async {
    emit(WishStart());
    final failureOrWish = await createWish(WishparamsCreate(wish: wishEntity));
    emit(failureOrWish.fold(
        (failure) => WishError(message: mapFailureFromMessage(failure)),
        (wish) => WishLoaded(wish: wish)));
  }

  // Future<void> editWish(WishparamsUpdate params) async {
  //   emit(WishOperationInProgress());
  //   final result = await updateWish(params);
  //   result.fold(
  //     (failure) => emit(WishError(message: mapFailureFromMessage(failure))),
  //     (_) {
  //       emit(WishOperationSuccess());
  //       if (state is WishesLoaded) {
  //         final currentState = state as WishesLoaded;
  //         final updatedWishes = currentState.wishes
  //             .map((w) => w.id == params.wish ? params.wish : w)
  //             .toList();
  //         emit(WishesLoaded(
  //           wishes: updatedWishes,
  //           roomId: currentState.roomId,
  //         ));
  //       }
  //     },
  //   );
  // }

  // Future<void> removeWish(WishparamsDelete params) async {
  //   emit(WishOperationInProgress());
  //   final result = await deleteWish(params);
  //   result.fold(
  //     (failure) => emit(WishError(message: mapFailureFromMessage(failure))),
  //     (_) {
  //       emit(WishOperationSuccess());
  //       if (state is WishesLoaded) {
  //         final currentState = state as WishesLoaded;
  //         emit(WishesLoaded(
  //           wishes: currentState.wishes
  //               .where((w) => w.id != params.wishId)
  //               .toList(),
  //           roomId: currentState.roomId,
  //         ));
  //       }
  //     },
  //   );
  // }

  // Future<void> markAsFulfilled(WishparamsFulfill params) async {
  //   emit(WishOperationInProgress());
  //   final result = await fulfillWish(params);
  //   result.fold(
  //     (failure) => emit(WishError(message: mapFailureFromMessage(failure))),
  //     (_) {
  //       emit(WishOperationSuccess());
  //       if (state is WishesLoaded) {
  //         final currentState = state as WishesLoaded;
  //         final updatedWishes = currentState.wishes.map((w) {
  //           if (w.id == params.wishId) {
  //             return w.copyWith(isFulfilled: true, fulfilledBy: params.userId);
  //           }
  //           return w;
  //         }).toList();
  //         emit(WishesLoaded(
  //           wishes: updatedWishes,
  //           roomId: currentState.roomId,
  //         ));
  //       }
  //     },
  //   );
  // }

  String mapFailureFromMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return "ServerFailure";
      default:
        return "Unexpected error";
    }
  }
}
