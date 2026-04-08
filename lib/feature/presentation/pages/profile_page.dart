import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';
import 'package:wishlist/feature/presentation/widgets/settings_bottom_sheet.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _pickBirthDate(
      BuildContext context, DateTime? current) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF6D57FC),
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && context.mounted) {
      context.read<UserCubit>().updateBirthDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          l10n.profile,
          style: const TextStyle(
            color: Color(0xFF6D57FC),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: Color(0xFF6D57FC), size: 28),
            onPressed: () => showSettingsBottomSheet(context),
          ),
        ],
      ),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserOperationSuccess) {
            context
                .read<UserCubit>()
                .fetchUserInfo(supabase.auth.currentUser!.id);
          }
        },
        builder: (context, state) {
          final name = state is UserLoaded ? state.users.name : '...';
          final birthDate = state is UserLoaded ? state.users.birthDate : null;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xFFE8E4FF),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D57FC),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF120E00),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.birthDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _pickBirthDate(context, birthDate),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            birthDate != null
                                ? DateFormat('d MMMM yyyy',
                                        Localizations.localeOf(context)
                                            .languageCode)
                                    .format(birthDate)
                                : l10n.notSpecified,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: birthDate != null
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        const Icon(Icons.edit_outlined,
                            color: Colors.grey, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
