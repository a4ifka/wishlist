import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/usecases/user/sign_up_user.dart';
import 'package:wishlist/feature/presentation/cubit/sign_up_cubit/sign_up_state.dart';

class SignUpUserCubit extends Cubit<SignUpUserState> {
  final SignUpUser signUpUser;

  SignUpUserCubit({required this.signUpUser}) : super(SignUpUserInitial());

  auth(String email, String password) async {
    emit(SignUpUserStart());

    final failureOrUser =
        await signUpUser(UserSignUpParams(email: email, password: password));
    emit(failureOrUser.fold(
        (failure) => SignUpUserError(message: mapFailureFromMessage(failure)),
        (auth) => SignUpUserLoaded(user: auth)));
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
