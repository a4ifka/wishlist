import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/presentation/cubit/room_cubit/room_cubit.dart';

void showAddRoomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const _AddRoomBottomSheet(),
      );
    },
  );
}

class _AddRoomBottomSheet extends StatefulWidget {
  const _AddRoomBottomSheet({Key? key}) : super(key: key);

  @override
  State<_AddRoomBottomSheet> createState() => _AddRoomBottomSheetState();
}

class _AddRoomBottomSheetState extends State<_AddRoomBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isPublic = false;
  DateTime? _eventDate;

  static const _purple = Color.fromRGBO(155, 121, 246, 1);

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _eventDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(109, 87, 252, 1),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 20, 26, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'Новый ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'вишлист',
                    style: TextStyle(color: Color.fromRGBO(109, 87, 252, 1)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Название
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration('Название'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите название вишлиста';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Дата праздника
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: _inputDecoration(
                          _eventDate != null
                              ? DateFormat('d MMMM yyyy', 'ru').format(_eventDate!)
                              : 'Дата праздника',
                          suffixIcon: _eventDate != null
                              ? GestureDetector(
                                  onTap: () =>
                                      setState(() => _eventDate = null),
                                  child: const Icon(Icons.close,
                                      color: Colors.grey),
                                )
                              : const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                        ),
                        validator: (value) {
                          if (_eventDate == null) {
                            return 'Укажите дату праздника';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Публичный
                  SwitchListTile(
                    title: const Text('Публичная комната'),
                    subtitle: const Text('Видна всем пользователям'),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: const Color.fromRGBO(109, 87, 252, 1),
                    value: _isPublic,
                    onChanged: (value) => setState(() => _isPublic = value),
                  ),
                  const SizedBox(height: 16),

                  // Кнопка
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(65),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final roomEntity = RoomEntity(
                            id: 0,
                            name: _nameController.text,
                            isPublic: _isPublic,
                            eventDate: _eventDate,
                          );
                          context.read<RoomCubit>().addRoom(roomEntity);
                        }
                      },
                      child: const Text(
                        'Добавить',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocListener<RoomCubit, RoomState>(
                    listener: (context, state) {
                      if (state is RoomLoaded) {
                        Navigator.pop(context);
                      } else if (state is RoomError) {
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
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(color: Color.fromRGBO(155, 121, 246, 1), width: 3),
    );
    return InputDecoration(
      contentPadding: const EdgeInsets.only(left: 20, top: 14, bottom: 14),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      suffixIcon: suffixIcon,
      border: border,
      enabledBorder: border,
      focusedBorder: border,
      errorBorder: border,
      focusedErrorBorder: border,
    );
  }
}
