import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/presentation/cubit/locale_cubit/locale_cubit.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/main.dart';

void showSettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<LocaleCubit>(),
      child: const _SettingsSheet(),
    ),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final isRu = locale.languageCode == 'ru';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D57FC),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.language,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<LocaleCubit>().setRussian(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: isRu
                              ? const Color(0xFF6D57FC)
                              : const Color(0xFFF6F5F8),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFF9B79F6),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Русский',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isRu ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<LocaleCubit>().setEnglish(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: !isRu
                              ? const Color(0xFF6D57FC)
                              : const Color(0xFFF6F5F8),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFF9B79F6),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'English',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: !isRu ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Немедленный выход: сначала навигация, потом signOut в фоне
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/signIn',
                      (route) => false,
                    );
                    supabase.auth.signOut();
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(
                    l10n.signOut,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
