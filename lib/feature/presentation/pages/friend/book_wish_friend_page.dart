import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/book_wish_list_item.dart';
import 'package:wishlist/l10n/app_localizations.dart';

class BookWishFriendPage extends StatefulWidget {
  const BookWishFriendPage({super.key});

  @override
  State<BookWishFriendPage> createState() => _BookWishFriendPageState();
}

class _BookWishFriendPageState extends State<BookWishFriendPage> {
  bool _initialized = false;
  late RoomEntity _room;
  RealtimeChannel? _wishesChannel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _room = ModalRoute.of(context)!.settings.arguments as RoomEntity;
      context.read<WishCubit>().fetchWishesByRoom(_room.id);
      _wishesChannel = Supabase.instance.client
          .channel('book_wishes:${_room.id}')
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'wishes',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'room_id',
              value: _room.id,
            ),
            callback: (_) =>
                context.read<WishCubit>().fetchWishesByRoom(_room.id),
          )
          .subscribe();
    }
  }

  @override
  void dispose() {
    _wishesChannel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 45),
          // ── Шапка ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/back.svg'),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                if (_room.eventDate != null)
                  _Chip(
                    label: DateFormat('d MMMM yyyy', locale)
                        .format(_room.eventDate!),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _room.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  color: Color(0xFF6D57FC),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ── Список ────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<WishCubit, WishState>(
              builder: (context, state) {
                if (state is WishesLoaded) {
                  if (state.wishes.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noWishesYet,
                        style: const TextStyle(
                          color: Color(0xFFC7B5FA),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                        ),
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: state.wishes.length,
                    itemBuilder: (context, index) {
                      return BookWishListItem(product: state.wishes[index]);
                    },
                  );
                } else if (state is WishError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6D57FC),
                    ),
                  );
                }
              },
            ),
          ),
          // ── Снэкбар-слушатель ──────────────────────────────────────
          BlocListener<WishCubit, WishState>(
            listener: (context, state) {
              if (state is WishesSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.success),
                    backgroundColor: const Color(0xFF6D57FC),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                context.read<WishCubit>().fetchWishesByRoom(_room.id);
              } else if (state is WishError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.operationError),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            },
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(199, 181, 250, 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Nunito',
          color: Color(0xFF6D57FC),
        ),
      ),
    );
  }
}
