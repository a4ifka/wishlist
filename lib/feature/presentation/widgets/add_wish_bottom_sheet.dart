import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';

void showAddWishBottomSheet(BuildContext context, int roomId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Для возможности прокрутки
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Учет клавиатуры
      ),
      child: _AddWishBottomSheet(roomId: roomId),
    ),
  );
}

class _AddWishBottomSheet extends StatefulWidget {
  final int roomId;
  const _AddWishBottomSheet({required this.roomId});

  @override
  _AddWishBottomSheetState createState() => _AddWishBottomSheetState();
}

class _AddWishBottomSheetState extends State<_AddWishBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _link2Controller = TextEditingController();
  final TextEditingController _link3Controller = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _linkController.dispose();
    _link2Controller.dispose();
    _link3Controller.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Создать подарок',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Название',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
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
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Цена',
                        prefixText: '₽ ',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
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
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Ссылка на картинку',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, укажите ссылку на изображение';
                        }
                        // if (!Uri.tryParse(value)!.hasAbsolutePath) {
                        //   return 'Введите корректную ссылку';
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _linkController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Где можно купить(ссылка)',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, укажите ссылку';
                        }
                        // if (!Uri.tryParse(value)!.hasAbsolutePath) {
                        //   return 'Введите корректную ссылку';
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _link2Controller,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Где можно купить(ссылка)',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, укажите ссылку';
                        }
                        // if (!Uri.tryParse(value)!.hasAbsolutePath) {
                        //   return 'Введите корректную ссылку';
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _link3Controller,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 20),
                        hintText: 'Где можно купить(ссылка)',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(155, 121, 246, 1),
                              width: 3),
                        ),
                      ),
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, укажите ссылку';
                        }
                        // if (!Uri.tryParse(value)!.hasAbsolutePath) {
                        //   return 'Введите корректную ссылку';
                        // }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor:
                                const Color.fromRGBO(155, 121, 246, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(65),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final wishEntity = WishEntity(
                                id: 0,
                                roomId: widget.roomId,
                                name: _nameController.text,
                                url: _linkController.text,
                                url2: _link2Controller.text.isEmpty
                                    ? ''
                                    : _link2Controller.text,
                                url3: _link3Controller.text.isEmpty
                                    ? ''
                                    : _link3Controller.text,
                                imageUrl: _imageUrlController.text,
                                price:
                                    double.tryParse(_priceController.text) ?? 0,
                                isFulfilled: false,
                              );
                              context.read<WishCubit>().addWish(wishEntity);
                              // Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'Добавить',
                            style: TextStyle(
                              fontSize: 16, // Размер текста
                              fontWeight: FontWeight.w600, // Жирность текста
                            ),
                          ),
                        ),
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
          ],
        ),
      ),
    );
  }
}
