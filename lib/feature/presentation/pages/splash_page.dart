import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';

import 'package:wishlist/main.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null) {
      context.read<UserCubit>().fetchUserInfo(supabase.auth.currentUser!.id);
    } else {
      Navigator.of(context).pushReplacementNamed('/signUp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const Text('WishList'),
          BlocListener<UserCubit, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                Navigator.of(context).pushReplacementNamed('/navigation');
              } else if (state is UserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                Navigator.of(context).pushReplacementNamed('/create-user');
              }
            },
            child: const SizedBox(),
          ),
        ],
      )),
    );
  }
}
