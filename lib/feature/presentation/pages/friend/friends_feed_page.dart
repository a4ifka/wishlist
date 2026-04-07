import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';

class FriendsFeedPage extends StatefulWidget {
  const FriendsFeedPage({super.key});

  @override
  State<FriendsFeedPage> createState() => _FriendsFeedPageState();
}

class _FriendsFeedPageState extends State<FriendsFeedPage> {
  static const _purple = Color(0xFF6D57FC);

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  void _loadFeed() {
    final cubit = context.read<FriendCubit>();
    cubit
        .fetchListFriends(Supabase.instance.client.auth.currentUser!.id)
        .then((_) {
      final state = cubit.state;
      if (state is FriendListSuccess) {
        cubit.fetchAllFriendsRooms(state.users);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Шапка ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Друзья',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _purple,
                          ),
                        ),
                        Text(
                          'Вишлисты твоих друзей',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  // Кнопка — меню друзей
                  _FriendsMenuButton(),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Лента ──────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<FriendCubit, FriendState>(
                builder: (context, state) {
                  if (state is FriendStart) {
                    return const Center(
                      child: CircularProgressIndicator(color: _purple),
                    );
                  }

                  if (state is AllFriendsRoomsLoaded) {
                    final entries = state.roomsByFriend.entries
                        .expand((e) => e.value.map((r) => (e.key, r)))
                        .where((pair) => pair.$2.isPublic)
                        .toList()
                      // Сортируем: ближайшие праздники вверху
                      ..sort((a, b) {
                        final da = a.$2.eventDate;
                        final db = b.$2.eventDate;
                        if (da == null && db == null) return 0;
                        if (da == null) return 1;
                        if (db == null) return -1;
                        return da.compareTo(db);
                      });

                    if (entries.isEmpty) {
                      return _EmptyFeed();
                    }

                    return RefreshIndicator(
                      color: _purple,
                      onRefresh: () async => _loadFeed(),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        itemCount: entries.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final friend = entries[i].$1;
                          final room = entries[i].$2;
                          return _RoomFeedCard(
                            friend: friend,
                            room: room,
                          );
                        },
                      ),
                    );
                  }

                  return _EmptyFeed();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Кнопка-меню с друзьями ────────────────────────────────────────────────────

class _FriendsMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFriendsMenu(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF6D57FC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_outline, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              'Друзья',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFriendsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _FriendsMenuSheet(),
    );
  }
}

class _FriendsMenuSheet extends StatelessWidget {
  static const _purple = Color(0xFF6D57FC);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Друзья',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _purple,
            ),
          ),
          const SizedBox(height: 20),
          _MenuTile(
            icon: Icons.search_rounded,
            label: 'Найти друга',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/search-friend');
            },
          ),
          const SizedBox(height: 10),
          _MenuTile(
            icon: Icons.notifications_none_rounded,
            label: 'Заявки в друзья',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/request-friend');
            },
          ),
          const SizedBox(height: 10),
          // Список друзей
          BlocBuilder<FriendCubit, FriendState>(
            builder: (context, state) {
              if (state is FriendListSuccess && state.users.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 8),
                      child: Text(
                        'Мои друзья',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ...state.users.map(
                      (u) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _MenuTile(
                          icon: Icons.person_outline,
                          label: u.name,
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/rooms-friend',
                                arguments: u);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6D57FC), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── Карточка вишлиста в ленте ─────────────────────────────────────────────────

class _RoomFeedCard extends StatelessWidget {
  final UserEntity friend;
  final RoomEntity room;

  static const _purple = Color(0xFF6D57FC);
  static const _lightPurple = Color(0xFFC7B5FA);

  const _RoomFeedCard({required this.friend, required this.room});

  String _daysLabel() {
    final date = room.eventDate;
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final event = DateTime(date.year, date.month, date.day);
    final diff = event.difference(today).inDays;
    if (diff == 0) return 'Сегодня!';
    if (diff == 1) return 'Завтра';
    if (diff < 0) return '';
    return 'Через $diff дн.';
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = room.eventDate != null
        ? DateFormat('d MMMM yyyy', 'ru').format(room.eventDate!)
        : null;
    final daysLabel = _daysLabel();

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/book-wishes', arguments: room),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Друг + дата
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _lightPurple.withValues(alpha: 0.4),
                  child: Text(
                    friend.name.isNotEmpty
                        ? friend.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: _purple,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    friend.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                if (daysLabel.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: daysLabel == 'Сегодня!' || daysLabel == 'Завтра'
                          ? const Color(0xFFFF9ECC).withValues(alpha: 0.3)
                          : _lightPurple.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      daysLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: daysLabel == 'Сегодня!' || daysLabel == 'Завтра'
                            ? Colors.pinkAccent
                            : _purple,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Название вишлиста
            Text(
              room.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            if (dateLabel != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.cake_outlined,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    dateLabel,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 14),

            // Кнопка
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                    context, '/book-wishes',
                    arguments: room),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Смотреть и бронировать',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Пустая лента ──────────────────────────────────────────────────────────────

class _EmptyFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.card_giftcard_outlined,
              size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          const Text(
            'Пока тут пусто',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Добавь друзей, чтобы видеть их вишлисты',
            style: TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/search-friend'),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF6D57FC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Найти друзей',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
