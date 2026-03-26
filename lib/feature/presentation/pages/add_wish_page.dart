import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';

class AddWishPage extends StatefulWidget {
  const AddWishPage({super.key});

  @override
  State<AddWishPage> createState() => _AddWishPageState();
}

class _AddWishPageState extends State<AddWishPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _linkController = TextEditingController();
  final _link2Controller = TextEditingController();
  final _link3Controller = TextEditingController();

  XFile? _selectedImage;
  Uint8List? _imageBytes;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _linkController.dispose();
    _link2Controller.dispose();
    _link3Controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _selectedImage = picked;
        _imageBytes = bytes;
      });
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 20),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color.fromRGBO(155, 121, 246, 1), width: 3),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color.fromRGBO(155, 121, 246, 1), width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color.fromRGBO(155, 121, 246, 1), width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color.fromRGBO(155, 121, 246, 1), width: 3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(color: Color.fromRGBO(155, 121, 246, 1), width: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomId = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Создать подарок')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Название
              TextFormField(
                controller: _nameController,
                decoration: _fieldDecoration('Название'),
                validator: (v) => (v == null || v.isEmpty) ? 'Введите название' : null,
              ),
              const SizedBox(height: 16),
              // Цена
              TextFormField(
                controller: _priceController,
                decoration: _fieldDecoration('Цена').copyWith(prefixText: '₽ '),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Укажите цену';
                  if (double.tryParse(v) == null) return 'Введите корректную цену';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Выбор фото
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(246, 245, 248, 1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromRGBO(155, 121, 246, 1),
                      width: 2,
                    ),
                  ),
                  child: _imageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 48, color: Color.fromRGBO(155, 121, 246, 1)),
                            SizedBox(height: 8),
                            Text(
                              'Добавить фото',
                              style: TextStyle(
                                color: Color.fromRGBO(155, 121, 246, 1),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              // Ссылки
              TextFormField(
                controller: _linkController,
                decoration: _fieldDecoration('Где можно купить (ссылка 1)'),
                keyboardType: TextInputType.url,
                validator: (v) => (v == null || v.isEmpty) ? 'Укажите ссылку' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _link2Controller,
                decoration: _fieldDecoration('Где можно купить (ссылка 2, необязательно)'),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _link3Controller,
                decoration: _fieldDecoration('Где можно купить (ссылка 3, необязательно)'),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  if (_imageBytes == null || _selectedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Пожалуйста, добавьте фото')),
                    );
                    return;
                  }
                  final wish = WishEntity(
                    id: 0,
                    roomId: roomId,
                    name: _nameController.text,
                    url: _linkController.text,
                    url2: _link2Controller.text,
                    url3: _link3Controller.text,
                    imageUrl: '',
                    price: double.parse(_priceController.text),
                    isFulfilled: false,
                  );
                  final fileName =
                      '${DateTime.now().millisecondsSinceEpoch}_${_selectedImage!.name}';
                  context.read<WishCubit>().addWishWithImage(wish, _imageBytes!, fileName);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromRGBO(109, 87, 252, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Создать подарок',
                  style: TextStyle(fontSize: 16, color: Colors.white),
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
