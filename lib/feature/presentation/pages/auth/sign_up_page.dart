import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/feature/presentation/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/sign_up_cubit/sign_up_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final reapetPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    reapetPasswordController.dispose();
    super.dispose();
  }

  OutlineInputBorder _border({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: focused
            ? const Color(0xFF6D57FC)
            : const Color.fromRGBO(155, 121, 246, 1),
        width: focused ? 2 : 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  l10n.register,
                  style: const TextStyle(
                    color: Color(0xFF6D57FC),
                    fontSize: 36,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.passwordHint,
                  style: const TextStyle(
                    color: Color(0xFF120E00),
                    fontSize: 16,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  alignment: Alignment.bottomRight,
                  child: Image.asset('assets/Green.png'),
                ),
                // Email
                Text(
                  l10n.email,
                  style: const TextStyle(
                    color: Color(0xFF120E00),
                    fontSize: 14,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    hintText: l10n.email,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: _border(),
                    enabledBorder: _border(),
                    focusedBorder: _border(focused: true),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.password,
                  style: const TextStyle(
                    color: Color(0xFF120E00),
                    fontSize: 14,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    hintText: l10n.password,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: _border(),
                    enabledBorder: _border(),
                    focusedBorder: _border(focused: true),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9B79F6),
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.reppassword,
                  style: const TextStyle(
                    color: Color(0xFF120E00),
                    fontSize: 14,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: reapetPasswordController,
                  obscureText: _obscureRepeatPassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    hintText: l10n.reppassword,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: _border(),
                    enabledBorder: _border(),
                    focusedBorder: _border(focused: true),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureRepeatPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color(0xFF9B79F6),
                      ),
                      onPressed: () => setState(
                          () => _obscureRepeatPassword = !_obscureRepeatPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (passwordController.text ==
                          reapetPasswordController.text) {
                        context.read<SignUpUserCubit>().auth(
                            emailController.text, passwordController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.passwordsMismatch),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D57FC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(77),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.next,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/signIn");
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.alreadyHaveAccount,
                      style: const TextStyle(
                        color: Color(0xFF6D57FC),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 1.60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocListener<SignUpUserCubit, SignUpUserState>(
                  listener: (context, state) {
                    if (state is SignUpUserLoaded) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/create-user",
                          arguments: state.user.user?.id);
                    } else if (state is SignUpUserError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.authError),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
