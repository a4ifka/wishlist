import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/usecases/friend/get_friend_requests.dart';
import 'package:wishlist/feature/domain/usecases/friend/get_friend_rooms.dart';
import 'package:wishlist/feature/domain/usecases/friend/get_friends.dart';
import 'package:wishlist/feature/domain/usecases/friend/get_list_friends.dart';
import 'package:wishlist/feature/domain/usecases/friend/respond_to_friend_request.dart';
import 'package:wishlist/feature/domain/usecases/friend/seatch_users.dart';
import 'package:wishlist/feature/domain/usecases/friend/send_friend_request.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';

class FriendCubit extends Cubit<FriendState> {
  final GetFriendRequests getFriendRequests;
  final GetFriends getFriends;
  final RespondToFriendRequest respondToFriendRequest;
  final SeatchUsers seatchUsers;
  final SendFriendRequest sendFriendRequest;
  final GetListFriends getListFriends;
  final GetFriendRooms getFriendRooms;

  FriendCubit({
    required this.getFriendRequests,
    required this.getFriends,
    required this.respondToFriendRequest,
    required this.seatchUsers,
    required this.sendFriendRequest,
    required this.getListFriends,
    required this.getFriendRooms,
  }) : super(FriendInitial());

  fetchFriendRequests(String userId) async {
    emit(FriendStart());
    final failureOrFriends =
        await getFriendRequests(FriendGetRequestParams(userId: userId));
    emit(failureOrFriends.fold(
        (failure) => FriendError(message: mapFailureFromMessage(failure)),
        (friends) => FriendRequestsLoaded(friends)));
  }

  fetchFriends(String userId) async {
    emit(FriendStart());
    final failureOrFriends = await getFriends(FriendGetParams(userId: userId));
    emit(failureOrFriends.fold(
        (failure) => FriendError(message: mapFailureFromMessage(failure)),
        (friends) => FriendListLoaded(friends)));
  }

  setRespondToFriendRequest(String requestId, bool accept) async {
    emit(FriendStart());
    final failureOrFriends = await respondToFriendRequest(
        RespondToFriendRequestParams(requestId: requestId, accept: accept));
    emit(failureOrFriends.fold(
        (failure) => FriendError(message: mapFailureFromMessage(failure)),
        (nope) => FriendActionSuccess(
            accept ? 'Request accepted' : 'Request rejected')));
  }

  searchUsers(String query) async {
    emit(FriendStart());
    final failureOrFriends = await seatchUsers(SeatchUsersParams(query: query));
    emit(failureOrFriends.fold(
        (failure) => FriendError(message: mapFailureFromMessage(failure)),
        (users) => FriendSearchSuccess(users)));
  }

  sentFriendRequest(String senderId, String receiverId) async {
    emit(FriendStart());
    final failureOrAction = await sendFriendRequest(
        SendFriendRequestParams(senderId: senderId, receiverId: receiverId));
    emit(failureOrAction.fold(
        (failure) => FriendError(message: mapFailureFromMessage(failure)),
        (action) => FriendActionSuccess('Friend request sent')));
  }

  fetchListFriends(String userId) async {
    emit(FriendStart());
    final failureOrFriends =
        await getListFriends(GetListFriendsParams(userId: userId));
    emit(failureOrFriends.fold(
        (failure) => FriendError(message: mapFailureFromMessage(failure)),
        (friends) => FriendListSuccess(friends)));
  }

  fetchFriendRooms(String uuid) async {
    emit(FriendStart());
    final failureOrRooms =
        await getFriendRooms(GetFriendRoomsParams(uuid: uuid));
    emit(failureOrRooms.fold(
        (failure) => FriendError(message: mapFailureFromMessage(failure)),
        (room) => FriendRoomsSuccess(room)));
  }

  String mapFailureFromMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return "ServerFailure";
      default:
        return "Unexpected error";
    }
  }
}
