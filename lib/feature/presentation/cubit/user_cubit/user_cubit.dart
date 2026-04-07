import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/domain/repositories/user_repository.dart';
import 'package:wishlist/feature/domain/usecases/user/create_user.dart';

import 'package:wishlist/feature/domain/usecases/user/get_user_info.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUserInfo getUserInfo;
  final CreateUser createUser;
  final UserRepository userRepository;

  UserCubit({
    required this.getUserInfo,
    required this.createUser,
    required this.userRepository,
  }) : super(UserInitial());

  fetchUserInfo(String uuid) async {
    emit(UserStart());
    final failureOrInfo = await getUserInfo(UserParams(uuid: uuid));
    emit(failureOrInfo.fold(
        (failure) => UserError(message: mapFailureFromMessage(failure)),
        (info) => UserLoaded(users: info)));
  }

  updateBirthDate(DateTime birthDate) async {
    final result = await userRepository.updateBirthDate(birthDate);
    result.fold(
      (failure) => emit(UserError(message: mapFailureFromMessage(failure))),
      (_) => emit(UserOperationSuccess()),
    );
  }

  addUser(UserEntity userModel) async {
    emit(UserStart());
    final failureOrInfo =
        await createUser(UserParamsCreate(userModel: userModel));
    emit(failureOrInfo.fold(
        (failure) => UserError(message: mapFailureFromMessage(failure)),
        (user) => UserCreated()));
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
