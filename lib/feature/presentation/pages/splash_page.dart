import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wishlist/core/services/notification_service.dart';
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
      NotificationService.onUserLoggedIn();
      context.read<UserCubit>().fetchUserInfo(supabase.auth.currentUser!.id);
    } else {
      Navigator.of(context).pushReplacementNamed('/signUp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/splash.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
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
      ),
    );
  }
}
