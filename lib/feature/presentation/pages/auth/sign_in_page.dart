import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wishlist/feature/presentation/cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/sign_in_cubit/sign_in_state.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.login,
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
          ElevatedButton(
            onPressed: () {
              context
                  .read<SignInUserCubit>()
                  .auth(emailController.text, passwordController.text);
            },
            child: Text(
              AppLocalizations.of(context)!.next,
              style: const TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/signUp");
            },
            child: Text(
              AppLocalizations.of(context)!.register,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          BlocListener<SignInUserCubit, SignInUserState>(
            listener: (context, state) {
              if (state is SignInUserLoaded) {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/navigation",
                    arguments: state.user);
              } else if (state is SignInUserError) {
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
