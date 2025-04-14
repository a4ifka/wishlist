// import 'package:flutter/material.dart';
// import 'package:wishlist/feature/domain/entities/room_entity.dart';

// class RoomListItem extends StatelessWidget {
//   final RoomEntity roomEntity;

//   const RoomListItem({
//     super.key,
//     required this.roomEntity,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         roomEntity.name,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       subtitle: Text(
//         roomEntity.isPublic ? 'Закрытый' : 'Открытый',
//         style: TextStyle(
//           color: roomEntity.isPublic ? Colors.red : Colors.green,
//         ),
//       ),
//       trailing: const Icon(Icons.chevron_right),
//       onTap: () {
//         Navigator.pushNamed(context, '/home/info', arguments: roomEntity);
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';

class RoomListItem extends StatefulWidget {
  final RoomEntity roomEntity;
  const RoomListItem({super.key, required this.roomEntity});

  @override
  State<RoomListItem> createState() => _RoomListItemState();
}

class _RoomListItemState extends State<RoomListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/home/info',
            arguments: widget.roomEntity);
      },
      child: ListTile(
        title: Text(
          widget.roomEntity.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          widget.roomEntity.isPublic ? 'Закрытый' : 'Открытый',
          style: TextStyle(
            color: widget.roomEntity.isPublic ? Colors.red : Colors.green,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
