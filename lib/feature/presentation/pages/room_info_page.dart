import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/wish_list_item.dart';
import 'package:wishlist/l10n/app_localizations.dart';


class RoomInfoPage extends StatefulWidget {
  const RoomInfoPage({super.key});

  @override
  State<RoomInfoPage> createState() => _RoomInfoPageState();
}

class _RoomInfoPageState extends State<RoomInfoPage> {
  bool _initialized = false;
  late RoomEntity _room;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _room = ModalRoute.of(context)!.settings.arguments as RoomEntity;
      context.read<WishCubit>().fetchWishesByRoom(_room.id);
    }
  }

  void _share(AppLocalizations l10n) {
    final url = 'https://wishgift-blue.vercel.app?room=${_room.id}';
    Share.share(l10n.inviteText(_room.name, url));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/back.svg'),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                _InfoChip(
                  label: _room.isPublic ? l10n.publicLabel : l10n.privateLabel,
                ),
                if (_room.eventDate != null) ...[
                  const SizedBox(width: 8),
                  _InfoChip(
                    label: DateFormat('d MMMM yyyy', locale)
                        .format(_room.eventDate!),
                  ),
                ],
                // Кнопка шаринга — только для публичных вишлистов
                if (_room.isPublic) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.ios_share_rounded,
                      color: Color(0xFF6D57FC),
                    ),
                    tooltip: l10n.share,
                    onPressed: () => _share(l10n),
                  ),
                ],
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
                  color: Color.fromRGBO(109, 87, 252, 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<WishCubit, WishState>(
              builder: (context, state) {
                if (state is WishesLoaded) {
                  if (state.wishes.isEmpty) {
                    return Center(child: Text(l10n.noWishesYet));
                  }
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: state.wishes.length,
                    itemBuilder: (context, index) {
                      return WishListItem(product: state.wishes[index]);
                    },
                  );
                } else if (state is WishError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text(l10n.loading));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromRGBO(155, 121, 246, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(65),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/add-wish',
                      arguments: _room.id);
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
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;

  const _InfoChip({required this.label});

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
          color: Color.fromRGBO(109, 87, 252, 1),
        ),
      ),
    );
  }
}
