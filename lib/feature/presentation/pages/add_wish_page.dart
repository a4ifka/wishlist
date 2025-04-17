import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';

class AddWishPage extends StatefulWidget {
  const AddWishPage({super.key});

  @override
  _AddWishScreenPage createState() => _AddWishScreenPage();
}

class _AddWishScreenPage extends State<AddWishPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _linkController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать подарок'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название подарка',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена',
                  border: OutlineInputBorder(),
                  prefixText: '₽ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, укажите цену';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите корректную цену';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                  labelText: 'Ссылка на подарок',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/gift',
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, укажите ссылку';
                  }
                  if (!Uri.tryParse(value)!.hasAbsolutePath) {
                    return 'Введите корректную ссылку';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Ссылка на картинку',
                  border: OutlineInputBorder(),
                  hintText: 'https://example.com/image.jpg',
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, укажите ссылку на изображение';
                  }
                  if (!Uri.tryParse(value)!.hasAbsolutePath) {
                    return 'Введите корректную ссылку';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  WishEntity wishEntity = WishEntity(
                      id: 0,
                      roomId: roomId,
                      name: _nameController.text,
                      url: _linkController.text,
                      url2: _linkController.text,
                      url3: _linkController.text,
                      imageUrl: _imageUrlController.text,
                      price: double.parse(_priceController.text),
                      isFulfilled: false);
                  context.read<WishCubit>().addWish(wishEntity);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Создать подарок',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              BlocListener<WishCubit, WishState>(
                listener: (context, state) {
                  if (state is WishLoaded) {
                    Navigator.pop(context);
                  } else if (state is WishError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
