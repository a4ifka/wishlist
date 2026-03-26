import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/domain/usecases/wish/create_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/delete_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/fulill_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/get_completed.dart';
import 'package:wishlist/feature/domain/usecases/wish/get_my_booking.dart';
import 'package:wishlist/feature/domain/usecases/wish/get_my_wishes_count.dart';
import 'package:wishlist/feature/domain/usecases/wish/upload_wish_image.dart';
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
  final GetMyBooking getMyBooking;
  final GetCompleted getCompleted;
  final GetMyWishesCount getMyWishesCount;
  final UploadWishImage uploadWishImage;

  WishCubit({
    required this.getWishesByRoom,
    required this.getWishById,
    required this.createWish,
    required this.updateWish,
    required this.deleteWish,
    required this.fulfillWish,
    required this.getMyBooking,
    required this.getCompleted,
    required this.getMyWishesCount,
    required this.uploadWishImage,
  }) : super(WishInitial());

  fetchWishesByRoom(int roomId) async {
    emit(WishStart());
    final failureOrUser = await getWishesByRoom(WishparamsRoom(roomId: roomId));
    emit(failureOrUser.fold(
      (failure) => WishError(message: mapFailureFromMessage(failure)),
      (wishes) => WishesLoaded(wishes: wishes),
    ));
  }

  fetchCounts() async {
    emit(WishStart());
    final results = await Future.wait([
      getMyWishesCount(const NoWishParams()),
      getCompleted(WishParamsGetCompleted(i: 0)),
      getMyBooking(WishParamsGetMyBooking(i: 0)),
    ]);
    final myWishes = results[0].getOrElse(() => 0);
    final completed = results[1].getOrElse(() => 0);
    final myBooking = results[2].getOrElse(() => 0);
    emit(WishCountsLoaded(
      myWishes: myWishes,
      completed: completed,
      myBooking: myBooking,
    ));
  }

  fetchMyBooking(int roomId) async {
    emit(WishStart());
    final failureOrUser = await getMyBooking(WishParamsGetMyBooking(i: 0));
    emit(failureOrUser.fold(
      (failure) => WishError(message: mapFailureFromMessage(failure)),
      (count) => WishesGetCountBooking(count: count),
    ));
  }

  fetchCompleted(int roomId) async {
    emit(WishStart());
    final failureOrUser = await getCompleted(WishParamsGetCompleted(i: 0));
    emit(failureOrUser.fold(
      (failure) => WishError(message: mapFailureFromMessage(failure)),
      (count) => WishesGetCountCompleted(count: count),
    ));
  }

  Future<void> loadWishById(WishparamsId params) async {
    emit(WishStart());
    final failureOrWish = await getWishById(params);
    emit(failureOrWish.fold(
        (failure) => WishError(message: mapFailureFromMessage(failure)),
        (wish) => WishGetLoaded(wish: wish)));
  }

  addWishWithImage(WishEntity wish, Uint8List imageBytes, String fileName) async {
    emit(WishStart());
    final uploadResult = await uploadWishImage(
      UploadWishImageParams(bytes: imageBytes, fileName: fileName),
    );
    await uploadResult.fold(
      (failure) async => emit(WishError(message: mapFailureFromMessage(failure))),
      (url) async {
        final wishWithImage = WishEntity(
          id: wish.id,
          roomId: wish.roomId,
          name: wish.name,
          url: wish.url,
          url2: wish.url2,
          url3: wish.url3,
          price: wish.price,
          imageUrl: url,
          isFulfilled: wish.isFulfilled,
          fulfilledBy: wish.fulfilledBy,
        );
        final createResult = await createWish(WishparamsCreate(wish: wishWithImage));
        emit(createResult.fold(
          (failure) => WishError(message: mapFailureFromMessage(failure)),
          (wish) => WishLoaded(wish: wish),
        ));
      },
    );
  }

  addWish(WishEntity wishEntity) async {
    emit(WishStart());
    final failureOrWish = await createWish(WishparamsCreate(wish: wishEntity));
    emit(failureOrWish.fold(
        (failure) => WishError(message: mapFailureFromMessage(failure)),
        (wish) => WishLoaded(wish: wish)));
  }

  markAsFulfilled(int wishId, String userId) async {
    emit(WishStart());
    final failureOrWish =
        await fulfillWish(WishparamsFulfill(wishId: wishId, userId: userId));
    emit(failureOrWish.fold(
        (failure) => WishError(message: mapFailureFromMessage(failure)),
        (wish) => WishesSuccess()));
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

  String mapFailureFromMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    return "Unexpected error";
  }
}
