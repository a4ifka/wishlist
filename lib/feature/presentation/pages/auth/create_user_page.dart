import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedBirthDate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(now.year - 20),
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
    if (picked != null) {
      setState(() => _selectedBirthDate = picked);
    }
  }

  OutlineInputBorder _border({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide(
        color: focused
            ? const Color(0xFF6D57FC)
            : const Color.fromRGBO(155, 121, 246, 1),
        width: focused ? 2 : 1.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                Text(
                  l10n.register,
                  style: const TextStyle(
                    color: Color(0xFF6D57FC),
                    fontSize: 36,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.enterYourNickname,
                  style: const TextStyle(
                    color: Color(0xFF120E00),
                    fontSize: 16,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.nickname,
                  style: const TextStyle(
                    color: Color(0xFF120E00),
                    fontSize: 14,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    hintText: l10n.nickname.toLowerCase(),
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: _border(),
                    enabledBorder: _border(),
                    focusedBorder: _border(focused: true),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.birthDateOptional,
                  style: const TextStyle(
                    color: Color(0xFF120E00),
                    fontSize: 14,
                    fontFamily: 'Verdana',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickBirthDate,
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color.fromRGBO(155, 121, 246, 1),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedBirthDate != null
                                ? DateFormat('d MMMM yyyy', locale)
                                    .format(_selectedBirthDate!)
                                : l10n.notSpecified,
                            style: TextStyle(
                              color: _selectedBirthDate != null
                                  ? const Color(0xFF120E00)
                                  : Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xFF9B79F6),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                BlocListener<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state is UserCreated) {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "/navigation");
                    } else if (state is UserError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.authError),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final uuid = ModalRoute.of(context)?.settings.arguments
                            as String?;
                        final effectiveUuid =
                            uuid ?? supabase.auth.currentUser?.id;
                        if (effectiveUuid == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.userNotAuthorized),
                            ),
                          );
                          return;
                        }
                        final name = _nameController.text;
                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.pleaseEnterNickname),
                            ),
                          );
                          return;
                        }
                        context.read<UserCubit>().addUser(
                              UserEntity(
                                id: 0,
                                name: name,
                                uuid: effectiveUuid,
                                birthDate: _selectedBirthDate,
                              ),
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
                        l10n.next,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
