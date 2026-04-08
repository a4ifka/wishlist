import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/presentation/cubit/room_cubit/room_cubit.dart';
import 'package:wishlist/l10n/app_localizations.dart';

void showAddRoomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: BlocProvider.value(
          value: context.read<RoomCubit>(),
          child: const _AddRoomBottomSheet(),
        ),
      );
    },
  );
}

class _AddRoomBottomSheet extends StatefulWidget {
  const _AddRoomBottomSheet();

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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(26, 20, 26, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: '${l10n.newWishlist.split(' ').first} ',
                    style: const TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: l10n.newWishlist.split(' ').skip(1).join(' '),
                    style: const TextStyle(
                        color: Color.fromRGBO(109, 87, 252, 1)),
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
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputDecoration(l10n.wishlistName),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterWishlistName;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: _inputDecoration(
                          _eventDate != null
                              ? DateFormat('d MMMM yyyy', locale)
                                  .format(_eventDate!)
                              : l10n.eventDate,
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
                        validator: (_) {
                          if (_eventDate == null) return l10n.enterEventDate;
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SwitchListTile(
                    title: Text(l10n.publicRoom),
                    subtitle: Text(l10n.publicRoomDesc),
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: const Color.fromRGBO(109, 87, 252, 1),
                    value: _isPublic,
                    onChanged: (value) => setState(() => _isPublic = value),
                  ),
                  const SizedBox(height: 16),
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
                          context.read<RoomCubit>().addRoom(
                                RoomEntity(
                                  id: 0,
                                  name: _nameController.text,
                                  isPublic: _isPublic,
                                  eventDate: _eventDate,
                                ),
                              );
                        }
                      },
                      child: Text(
                        l10n.add,
                        style: const TextStyle(
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
      borderSide:
          BorderSide(color: Color.fromRGBO(155, 121, 246, 1), width: 3),
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
