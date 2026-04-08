import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/main.dart';

class FriendSearchPage extends StatelessWidget {
  FriendSearchPage({super.key});

  final _searchController = TextEditingController();

  static const _purple = Color.fromRGBO(109, 87, 252, 1);
  static const _lightPurple = Color.fromRGBO(155, 121, 246, 1);

  void _search(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<FriendCubit>().searchUsers(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Шапка ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 20, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/back.svg'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.search,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6D57FC),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Заявки
                  _HeaderButton(
                    icon: Icons.notifications_none_rounded,
                    onTap: () =>
                        Navigator.pushNamed(context, '/request-friend'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Поиск ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 247, 249, 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _search(context),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: l10n.enterUsername,
                    hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 15),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: BlocBuilder<FriendCubit, FriendState>(
                      builder: (context, state) {
                        if (state is FriendStart) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _purple,
                              ),
                            ),
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.arrow_forward_rounded,
                              color: _purple),
                          onPressed: () => _search(context),
                        );
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Результаты ─────────────────────────────────────────
            Expanded(
              child: BlocConsumer<FriendCubit, FriendState>(
                listener: (context, state) {
                  if (state is FriendActionSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.requestSent),
                        backgroundColor: _lightPurple,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  } else if (state is FriendError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is FriendSearchSuccess) {
                    if (state.users.isEmpty) {
                      return _EmptyState(
                        icon: Icons.person_search_outlined,
                        text: l10n.nobodyFound,
                        sub: l10n.tryAnotherName,
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: state.users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _UserCard(
                          user: state.users[index],
                          onAdd: () {
                            final me = supabase.auth.currentUser?.id;
                            if (me != null) {
                              context.read<FriendCubit>().sentFriendRequest(
                                    me,
                                    state.users[index].uuid,
                                  );
                            }
                          },
                        );
                      },
                    );
                  }

                  return _EmptyState(
                    icon: Icons.search_rounded,
                    text: l10n.startSearch,
                    sub: l10n.enterUsernameAbove,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Вспомогательные виджеты ───────────────────────────────────────────────────

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(247, 247, 249, 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color.fromRGBO(109, 87, 252, 1)),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onAdd;

  const _UserCard({required this.user, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(247, 247, 249, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Аватар
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color.fromRGBO(199, 181, 250, 0.5),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(109, 87, 252, 1),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Имя
          Expanded(
            child: Text(
              user.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Кнопка добавить
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(109, 87, 252, 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                AppLocalizations.of(context)!.add,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;
  final String sub;

  const _EmptyState({
    required this.icon,
    required this.text,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
