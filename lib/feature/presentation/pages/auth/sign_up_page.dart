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
                        color: const Color(0xFF6D57FC),
                        fontSize: 36,
                        fontFamily: 'Montserrat'),
                  ),
                  const Text(
                    'Придумайте пароль(не менее 8 символов)',
                    style: TextStyle(
                      color: const Color(0xFF120E00),
                      fontSize: 16,
                      fontFamily: 'Verdana',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                      width: double.infinity,
                      alignment: Alignment
                          .bottomRight, // Выравнивание содержимого слева
                      child: Image.asset('assets/Green.png')),
                  Container(
                    width: double.infinity,
                    height: 54,
                    padding: const EdgeInsets.only(
                      top: 0,
                      left: 20,
                      right: 35,
                    ),
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
                  // TextField(
                  //   controller: passwordController,
                  //   decoration: InputDecoration(
                  //     hintText: AppLocalizations.of(context)!.password,
                  //   ),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    height: 54,
                    padding: const EdgeInsets.only(
                      top: 0,
                      left: 20,
                      right: 35,
                    ),
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
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.password,
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
                  // TextField(
                  //   controller: reapetPasswordController,
                  //   decoration: InputDecoration(
                  //       hintText: AppLocalizations.of(context)!.reppassword),
                  // ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    height: 54,
                    padding: const EdgeInsets.only(
                      top: 0,
                      left: 20,
                      right: 35,
                    ),
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
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)!.reppassword,
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
                  const SizedBox(
                    height: 120,
                  ),
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
                        backgroundColor: const Color(
                            0xFF6D57FC), // Фиолетовый цвет из Frame334
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              77), // Скругление как в Frame334
                        ),

                        elevation: 0, // Убираем тень
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.next,
                        style: const TextStyle(
                          fontSize: 20, // Размер шрифта как в Frame334
                          color: Colors.white,
                          fontFamily: 'Montserat', // Шрифт из Frame334
                          fontWeight:
                              FontWeight.w400, // Толщина шрифта из Frame334
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
                        padding: EdgeInsets.zero, // Убираем стандартные отступы
                        tapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Уменьшаем область нажатия
                      ),
                      child: const Text(
                        'Уже есть аккаунт? Войдите',
                        style: TextStyle(
                          color: const Color(0xFF6D57FC),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          height: 1.60, // Добавляем подчеркивание (опционально)
                        ),
                      ),
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
            ),
          ),
        ),
      ),
    );
  }
}
