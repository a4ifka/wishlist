import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';
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
    // Важно освободить ресурсы при удалении виджета
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Укажите ваше имя'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Имя',
                hintText: 'Введите ваше имя',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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
                    const SnackBar(content: Text('Пожалуйста, введите имя')),
                  );
                }
              },
              child: const Text('Подтвердить'),
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
