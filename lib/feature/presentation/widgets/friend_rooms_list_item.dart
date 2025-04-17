import 'package:flutter/material.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';

class FriendRoomsListItem extends StatefulWidget {
  final RoomEntity roomEntity;
  const FriendRoomsListItem({super.key, required this.roomEntity});

  @override
  State<FriendRoomsListItem> createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendRoomsListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/book-wishes',
            arguments: widget.roomEntity);
      },
      child: ListTile(
        title: Text(
          widget.roomEntity.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.roomEntity.isPublic ? 'Открытый' : 'Закрытый',
          style: TextStyle(
            color: widget.roomEntity.isPublic ? Colors.green : Colors.red,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
