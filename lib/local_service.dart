import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/data/datasource/friend_remote_data_source.dart';
import 'package:wishlist/feature/data/datasource/room_remote_data_source.dart';
import 'package:wishlist/feature/data/datasource/user_remote_data_source.dart';
import 'package:wishlist/feature/data/datasource/wish_remote_data_source.dart';
import 'package:wishlist/feature/data/repositories/friend_repository_impl.dart';
import 'package:wishlist/feature/data/repositories/room_repository_impl.dart';
import 'package:wishlist/feature/data/repositories/user_repository_impl.dart';
import 'package:wishlist/feature/data/repositories/wish_repository_impl.dart';
import 'package:wishlist/feature/domain/repositories/friend_repository.dart';
import 'package:wishlist/feature/domain/repositories/room_repository.dart';
import 'package:wishlist/feature/domain/repositories/user_repository.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';
import 'package:wishlist/feature/domain/usecases/friend/get_friend_requests.dart';
import 'package:wishlist/feature/domain/usecases/friend/get_friends.dart';
import 'package:wishlist/feature/domain/usecases/friend/respond_to_friend_request.dart';
import 'package:wishlist/feature/domain/usecases/friend/seatch_users.dart';
import 'package:wishlist/feature/domain/usecases/friend/send_friend_request.dart';
import 'package:wishlist/feature/domain/usecases/room/create_room.dart';
import 'package:wishlist/feature/domain/usecases/room/delete_room.dart';
import 'package:wishlist/feature/domain/usecases/room/get_room_id.dart';
import 'package:wishlist/feature/domain/usecases/room/get_room_user.dart';
import 'package:wishlist/feature/domain/usecases/room/update_room.dart';
import 'package:wishlist/feature/domain/usecases/user/create_user.dart';
import 'package:wishlist/feature/domain/usecases/user/get_user_info.dart';
import 'package:wishlist/feature/domain/usecases/user/sign_in_user.dart';
import 'package:wishlist/feature/domain/usecases/user/sign_up_user.dart';
import 'package:wishlist/feature/domain/usecases/wish/create_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/delete_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/fulill_wish.dart';
import 'package:wishlist/feature/domain/usecases/wish/get_wish_id.dart';
import 'package:wishlist/feature/domain/usecases/wish/get_wish_room.dart';
import 'package:wishlist/feature/domain/usecases/wish/update_wish.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/room_cubit/room_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton<Supabase>(() => Supabase.instance);

  sl.registerLazySingleton(() => InternetConnectionChecker());

  // Cubit
  sl.registerFactory<FriendCubit>(() => FriendCubit(
      getFriendRequests: sl(),
      getFriends: sl(),
      respondToFriendRequest: sl(),
      seatchUsers: sl(),
      sendFriendRequest: sl()));

  sl.registerFactory<SignInUserCubit>(() => SignInUserCubit(signInUser: sl()));
  sl.registerFactory<SignUpUserCubit>(() => SignUpUserCubit(signUpUser: sl()));
  sl.registerFactory<UserCubit>(() => UserCubit(
        getUserInfo: sl(),
        createUser: sl(),
      ));
  sl.registerFactory<RoomCubit>(() => RoomCubit(
      getRoomsByUser: sl(),
      getRoomById: sl(),
      createRoom: sl(),
      updateRoom: sl(),
      deleteRoom: sl()));
  sl.registerFactory<WishCubit>(() => WishCubit(
      getWishesByRoom: sl(),
      getWishById: sl(),
      createWish: sl(),
      updateWish: sl(),
      deleteWish: sl(),
      fulfillWish: sl()));
  // usecases
  sl.registerLazySingleton<GetFriendRequests>(
      () => GetFriendRequests(repository: sl()));
  sl.registerLazySingleton<GetFriends>(() => GetFriends(repository: sl()));
  sl.registerLazySingleton<RespondToFriendRequest>(
      () => RespondToFriendRequest(repository: sl()));
  sl.registerLazySingleton<SeatchUsers>(() => SeatchUsers(repository: sl()));
  sl.registerLazySingleton<SendFriendRequest>(
      () => SendFriendRequest(repository: sl()));

  sl.registerLazySingleton<SignInUser>(() => SignInUser(userRepository: sl()));
  sl.registerLazySingleton<SignUpUser>(() => SignUpUser(userRepository: sl()));
  sl.registerLazySingleton<GetRoomById>(() => GetRoomById(repository: sl()));
  sl.registerLazySingleton<GetRoomsByUser>(
      () => GetRoomsByUser(repository: sl()));
  sl.registerLazySingleton<CreateRoom>(() => CreateRoom(repository: sl()));
  sl.registerLazySingleton<UpdateRoom>(() => UpdateRoom(repository: sl()));
  sl.registerLazySingleton<DeleteRoom>(() => DeleteRoom(repository: sl()));

  sl.registerLazySingleton<GetWishesByRoom>(
      () => GetWishesByRoom(repository: sl()));
  sl.registerLazySingleton<GetWishById>(() => GetWishById(repository: sl()));
  sl.registerLazySingleton<CreateWish>(() => CreateWish(repository: sl()));
  sl.registerLazySingleton<UpdateWish>(() => UpdateWish(repository: sl()));
  sl.registerLazySingleton<DeleteWish>(() => DeleteWish(repository: sl()));
  sl.registerLazySingleton<FulfillWish>(() => FulfillWish(repository: sl()));

  sl.registerLazySingleton<GetUserInfo>(() => GetUserInfo(repository: sl()));
  sl.registerLazySingleton<CreateUser>(() => CreateUser(repository: sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userRemoteDataSources: sl()));
  sl.registerLazySingleton<UserRemoteDataSources>(() =>
      UserRemoteDataSourcesImpl(supabaseClient: Supabase.instance.client));

  sl.registerLazySingleton<RoomRepository>(
      () => RoomRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<RoomRemoteDataSource>(
      () => RoomRemoteDataSourceImpl(supabaseClient: Supabase.instance.client));

  sl.registerLazySingleton<WishRepository>(
      () => WishRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<WishRemoteDataSource>(
      () => WishRemoteDataSourceImpl(supabaseClient: Supabase.instance.client));

  sl.registerLazySingleton<FriendRepository>(
      () => FriendRepositoryImpl(friendRemoteDataSource: sl()));
  sl.registerLazySingleton<FriendRemoteDataSource>(() =>
      FriendRemoteDataSourceImpl(supabaseClient: Supabase.instance.client));
}
