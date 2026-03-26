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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 99.0, right: 20, left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.register,
                    style: const TextStyle(
                        color: Color(0xFF6D57FC),
                        fontSize: 36,
                        fontFamily: 'Montserrat'),
                  ),
                  const Text(
                    'Придумайте пароль(не менее 8 символов)',
                    style: TextStyle(
                      color: Color(0xFF120E00),
                      fontSize: 16,
                      fontFamily: 'Verdana',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                      width: double.infinity,
                      alignment: Alignment.bottomRight,
                      child: Image.asset('assets/Green.png')),
                  // Email
                  Container(
                    width: double.infinity,
                    height: 54,
                    padding: const EdgeInsets.only(top: 0, left: 20, right: 35),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF6F5F8),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 2,
                          color: Color(0xFF9B79F6),
                        ),
                        borderRadius: BorderRadius.circular(53),
                      ),
                    ),
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.email,
                        hintStyle: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF616161),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Пароль
                  Container(
                    width: double.infinity,
                    height: 54,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF6F5F8),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 2,
                          color: Color(0xFF9B79F6),
                        ),
                        borderRadius: BorderRadius.circular(53),
                      ),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: AppLocalizations.of(context)!.password,
                        hintStyle: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9B79F6),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF616161),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Повторите пароль
                  Container(
                    width: double.infinity,
                    height: 54,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF6F5F8),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 2,
                          color: Color(0xFF9B79F6),
                        ),
                        borderRadius: BorderRadius.circular(53),
                      ),
                    ),
                    child: TextField(
                      controller: reapetPasswordController,
                      obscureText: _obscureRepeatPassword,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        hintText: AppLocalizations.of(context)!.reppassword,
                        hintStyle: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureRepeatPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF9B79F6),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureRepeatPassword = !_obscureRepeatPassword;
                            });
                          },
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF616161),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
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
                            const SnackBar(
                              content: Text('Пароли не совпадают!'),
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
                        AppLocalizations.of(context)!.next,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Montserat',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
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
                      child: const Text(
                        'Уже есть аккаунт? Войдите',
                        style: TextStyle(
                          color: Color(0xFF6D57FC),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.60,
                        ),
                      ),
                    ),
                  ),
                  BlocListener<SignUpUserCubit, SignUpUserState>(
                    listener: (context, state) {
                      if (state is SignUpUserLoaded) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/create-user",
                            arguments: state.user.user?.id);
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
            ),
          ),
        ),
      ),
    );
  }
}
