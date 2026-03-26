import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/main.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 99.0, right: 20, left: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.register,
                    style: const TextStyle(
                      color: Color(0xFF6D57FC),
                      fontSize: 36,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const Text(
                    'Введите свой ник',
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
                    child: Image.asset('assets/Green.png'),
                  ),
                  Container(
                    width: double.infinity,
                    height: 54,
                    padding: const EdgeInsets.only(left: 20, right: 35),
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
                ],
              ),
            ),
            const Spacer(),
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
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, bottom: 40),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final uuid =
                        ModalRoute.of(context)?.settings.arguments as String?;
                    final effectiveUuid = uuid ?? supabase.auth.currentUser?.id;
                    if (effectiveUuid == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Пользователь не авторизован'),
                        ),
                      );
                      return;
                    }
                    final name = _nameController.text;
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Пожалуйста, введите имя'),
                        ),
                      );
                      return;
                    }
                    context.read<UserCubit>().addUser(
                          UserEntity(id: 0, name: name, uuid: effectiveUuid),
                        );
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
            ),
          ],
        ),
      ),
    );
  }
}
