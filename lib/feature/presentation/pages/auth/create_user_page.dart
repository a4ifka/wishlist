import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';
import 'package:wishlist/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // Важно освободить ресурсы при удалении виджета
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
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
                      'Введите свой ник',
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
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'ник',
                          hintStyle: TextStyle(
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

                    // TextField(
                    //   controller: reapetPasswordController,
                    //   decoration: InputDecoration(
                    //       hintText: AppLocalizations.of(context)!.reppassword),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    UserEntity userModel = UserEntity(
                        id: 0,
                        name: _nameController.text,
                        uuid: supabase.auth.currentUser!.id);
                    String name = _nameController.text;
                    context.read<UserCubit>().addUser(userModel);
                    if (name.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Успешно')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Пожалуйста, введите имя')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF6D57FC), // Фиолетовый цвет из Frame334
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
                      fontWeight: FontWeight.w400, // Толщина шрифта из Frame334
                    ),
                  ),
                ),
              ),
            ),
            BlocListener<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserCreated) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/navigation");
                } else if (state is UserError) {
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
    );
  }
}
