import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/domain/entities/friend_entity.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/main.dart';

class FriendRequestPage extends StatefulWidget {
  const FriendRequestPage({super.key});

  @override
  State<FriendRequestPage> createState() => _FriendRequestPageState();
}

class _FriendRequestPageState extends State<FriendRequestPage> {
  int _tab = 0; // 0 — входящие, 1 — исходящие
  RealtimeChannel? _requestsChannel;

  static const _purple = Color.fromRGBO(109, 87, 252, 1);
  static const _lightPurple = Color.fromRGBO(199, 181, 250, 1);

  @override
  void initState() {
    super.initState();
    final userId = supabase.auth.currentUser?.id ?? '';
    context.read<FriendCubit>().fetchFriendRequests(userId);
    _requestsChannel = Supabase.instance.client
        .channel('friend_requests:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'friend_requset',
          callback: (_) =>
              context.read<FriendCubit>().fetchFriendRequests(userId),
        )
        .subscribe();
  }

  @override
  void dispose() {
    _requestsChannel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = supabase.auth.currentUser?.id ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Шапка ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 24, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset('assets/back.svg'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.friendRequests,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D57FC),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Таб-переключатель ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(247, 247, 249, 1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _Tab(
                      label: l10n.incoming,
                      selected: _tab == 0,
                      onTap: () => setState(() => _tab = 0),
                    ),
                    _Tab(
                      label: l10n.outgoing,
                      selected: _tab == 1,
                      onTap: () => setState(() => _tab = 1),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Список ─────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<FriendCubit, FriendState>(
                listener: (context, state) {
                  if (state is FriendActionSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            _tab == 0 ? l10n.responseSent : l10n.requestCancelled),
                        backgroundColor: _lightPurple,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                    context
                        .read<FriendCubit>()
                        .fetchFriendRequests(currentUserId);
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
                  if (state is FriendStart) {
                    return const Center(
                      child: CircularProgressIndicator(color: _purple),
                    );
                  }

                  if (state is FriendError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is FriendRequestsLoaded) {
                    final incoming = state.requests
                        .where((r) =>
                            r.receiverId == currentUserId &&
                            r.status == 'pending')
                        .toList();
                    final outgoing = state.requests
                        .where((r) =>
                            r.senderId == currentUserId &&
                            r.status == 'pending')
                        .toList();

                    final list = _tab == 0 ? incoming : outgoing;

                    if (list.isEmpty) {
                      return _EmptyState(
                        text: _tab == 0
                            ? l10n.noIncomingRequests
                            : l10n.noOutgoingRequests,
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final req = list[index];
                        return _tab == 0
                            ? _IncomingCard(
                                request: req,
                                onAccept: () =>
                                    _respond(context, currentUserId, req, true),
                                onDecline: () => _respond(
                                    context, currentUserId, req, false),
                              )
                            : _OutgoingCard(request: req);
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _respond(
      BuildContext context, String userId, FriendEntity req, bool accept) {
    context
        .read<FriendCubit>()
        .setRespondToFriendRequest(req.id.toString(), accept);
  }
}

// ── Таб ───────────────────────────────────────────────────────────────────────

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Tab(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? const Color.fromRGBO(109, 87, 252, 1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Входящая заявка ───────────────────────────────────────────────────────────

class _IncomingCard extends StatelessWidget {
  final FriendEntity request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _IncomingCard({
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(247, 247, 249, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color.fromRGBO(199, 181, 250, 0.5),
            child: Icon(
              Icons.person_outline,
              color: Color.fromRGBO(109, 87, 252, 1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              request.senderId,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Принять
          _ActionButton(
            icon: Icons.check_rounded,
            color: const Color.fromRGBO(109, 87, 252, 1),
            onTap: onAccept,
          ),
          const SizedBox(width: 8),
          // Отклонить
          _ActionButton(
            icon: Icons.close_rounded,
            color: const Color.fromRGBO(247, 247, 249, 1),
            iconColor: Colors.grey,
            bordered: true,
            onTap: onDecline,
          ),
        ],
      ),
    );
  }
}

// ── Исходящая заявка ──────────────────────────────────────────────────────────

class _OutgoingCard extends StatelessWidget {
  final FriendEntity request;

  const _OutgoingCard({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(247, 247, 249, 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color.fromRGBO(199, 181, 250, 0.5),
            child: Icon(
              Icons.person_outline,
              color: Color.fromRGBO(109, 87, 252, 1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              request.receiverId,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(199, 181, 250, 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              AppLocalizations.of(context)!.pending,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(109, 87, 252, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Кнопка действия ───────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final bool bordered;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    this.iconColor = Colors.white,
    this.bordered = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: bordered ? Border.all(color: Colors.grey.shade300) : null,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

// ── Пустое состояние ──────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String text;

  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mark_email_unread_outlined,
              size: 64, color: Colors.grey.shade300),
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
            AppLocalizations.of(context)!.emptyHere,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
