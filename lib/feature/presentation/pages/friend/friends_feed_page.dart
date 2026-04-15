import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
import 'package:wishlist/l10n/app_localizations.dart';

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
    context
        .read<FriendCubit>()
        .fetchListFriends(Supabase.instance.client.auth.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<FriendCubit, FriendState>(
      listener: (context, state) {
        if (state is FriendListSuccess) {
          context.read<FriendCubit>().fetchAllFriendsRooms(state.users);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.friends,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: _purple,
                            ),
                          ),
                          Text(
                            l10n.friendsWishlists,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    _FriendsMenuButton(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<FriendCubit, FriendState>(
                  builder: (context, state) {
                    if (state is FriendStart) {
                      return const Center(
                        child: CircularProgressIndicator(color: _purple),
                      );
                    }

                    if (state is AllFriendsRoomsLoaded) {
                      if (state.roomsByFriend.isEmpty) {
                        return _EmptyFeed();
                      }

                      final friendsWithRooms = <MapEntry<UserEntity, List<RoomEntity>>>[];
                      final friendsWithoutRooms = <UserEntity>[];

                      state.roomsByFriend.forEach((friend, rooms) {
                        final publicRooms = rooms.where((r) => r.isPublic).toList();
                        if (publicRooms.isNotEmpty) {
                          friendsWithRooms.add(MapEntry(friend, publicRooms));
                        } else {
                          friendsWithoutRooms.add(friend);
                        }
                      });

                      if (friendsWithRooms.isEmpty && friendsWithoutRooms.isEmpty) {
                        return _EmptyFeed();
                      }

                      friendsWithRooms.sort((a, b) {
                        final da = a.value.first.eventDate;
                        final db = b.value.first.eventDate;
                        if (da == null && db == null) return 0;
                        if (da == null) return 1;
                        if (db == null) return -1;
                        return da.compareTo(db);
                      });

                      friendsWithoutRooms.sort((a, b) => a.name.compareTo(b.name));

                      return RefreshIndicator(
                        color: _purple,
                        onRefresh: () async => _loadFeed(),
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          children: [
                            if (friendsWithRooms.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12, top: 8),
                                child: Text(
                                  l10n.friendsWithWishlists,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              ...friendsWithRooms.expand((entry) => 
                                entry.value.map((room) => _RoomFeedCard(
                                  friend: entry.key,
                                  room: room,
                                ))
                              ),
                            ],
                            if (friendsWithoutRooms.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: 12, 
                                  top: friendsWithRooms.isNotEmpty ? 24 : 8
                                ),
                                child: Text(
                                  l10n.friendsWithoutWishlists,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              ...friendsWithoutRooms.map((friend) => _FriendWithoutWishlistCard(
                                friend: friend,
                              )),
                            ],
                            const SizedBox(height: 20),
                          ],
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
      ),
    );
  }
}

class _FriendWithoutWishlistCard extends StatelessWidget {
  final UserEntity friend;
  static const _purple = Color(0xFF6D57FC);
  static const _lightPurple = Color(0xFFC7B5FA);

  const _FriendWithoutWishlistCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: _lightPurple.withValues(alpha: 0.4),
            child: Text(
              friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: _purple,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.noWishlistsYet,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.card_giftcard_outlined,
            color: Colors.grey.shade400,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class _FriendsMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => _showFriendsMenu(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF6D57FC),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              l10n.friends,
              style: const TextStyle(
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.friends,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _purple,
            ),
          ),
          const SizedBox(height: 20),
          _MenuTile(
            icon: Icons.search_rounded,
            label: l10n.findFriend,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/search-friend');
            },
          ),
          const SizedBox(height: 10),
          _MenuTile(
            icon: Icons.notifications_none_rounded,
            label: l10n.friendRequests,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/request-friend');
            },
          ),
          const SizedBox(height: 10),
          BlocBuilder<FriendCubit, FriendState>(
            builder: (context, state) {
              if (state is FriendListSuccess && state.users.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Text(
                        l10n.myFriends,
                        style: const TextStyle(
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

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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

class _RoomFeedCard extends StatelessWidget {
  final UserEntity friend;
  final RoomEntity room;

  static const _purple = Color(0xFF6D57FC);
  static const _lightPurple = Color(0xFFC7B5FA);

  const _RoomFeedCard({required this.friend, required this.room});

  (String, bool) _daysLabel(AppLocalizations l10n) {
    final date = room.eventDate;
    if (date == null) return ('', false);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final event = DateTime(date.year, date.month, date.day);
    final diff = event.difference(today).inDays;
    if (diff == 0) return (l10n.today, true);
    if (diff == 1) return (l10n.tomorrow, true);
    if (diff < 0) return ('', false);
    return (l10n.inNDays(diff), false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dateLabel = room.eventDate != null
        ? DateFormat('d MMMM yyyy', locale).format(room.eventDate!)
        : null;
    final (daysLabel, isUrgent) = _daysLabel(l10n);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/book-wishes', arguments: room),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: _lightPurple.withValues(alpha: 0.4),
                  child: Text(
                    friend.name.isNotEmpty ? friend.name[0].toUpperCase() : '?',
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? const Color(0xFFFF9ECC).withValues(alpha: 0.3)
                          : _lightPurple.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      daysLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isUrgent ? Colors.pinkAccent : _purple,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
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
                  Text(
                    dateLabel,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/book-wishes', arguments: room),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  l10n.viewAndBook,
                  style: const TextStyle(
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

class _EmptyFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.card_giftcard_outlined, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            l10n.feedEmpty,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.addFriendsToSeeFeed,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/search-friend'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF6D57FC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                l10n.findFriends,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}