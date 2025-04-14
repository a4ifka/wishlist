import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wishlist/feature/presentation/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/sign_up_cubit/sign_up_state.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reapetPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.register,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.email,
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.password,
            ),
          ),
          TextField(
            controller: reapetPasswordController,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.reppassword),
          ),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text == reapetPasswordController.text) {
                context
                    .read<SignUpUserCubit>()
                    .auth(emailController.text, passwordController.text);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Пароли не совпадают!'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: Text(
              AppLocalizations.of(context)!.next,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/signIn");
            },
            child: Text(
              AppLocalizations.of(context)!.login,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          BlocListener<SignUpUserCubit, SignUpUserState>(
            listener: (context, state) {
              if (state is SignUpUserLoaded) {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/create-user");
              } else if (state is SignUpUserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ошибка аутентификации!'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }
}
