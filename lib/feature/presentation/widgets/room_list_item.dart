// // import 'package:flutter/material.dart';
// // import 'package:wishlist/feature/domain/entities/room_entity.dart';

// // class RoomListItem extends StatelessWidget {
// //   final RoomEntity roomEntity;

// //   const RoomListItem({
// //     super.key,
// //     required this.roomEntity,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListTile(
// //       title: Text(
// //         roomEntity.name,
// //         style: const TextStyle(fontWeight: FontWeight.bold),
// //       ),
// //       subtitle: Text(
// //         roomEntity.isPublic ? 'Закрытый' : 'Открытый',
// //         style: TextStyle(
// //           color: roomEntity.isPublic ? Colors.red : Colors.green,
// //         ),
// //       ),
// //       trailing: const Icon(Icons.chevron_right),
// //       onTap: () {
// //         Navigator.pushNamed(context, '/home/info', arguments: roomEntity);
// //       },
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';

class RoomListItem extends StatefulWidget {
  final RoomEntity roomEntity;
  final int lengths;
  const RoomListItem(
      {super.key, required this.roomEntity, required this.lengths});

  @override
  State<RoomListItem> createState() => _RoomListItemState();
}

class _RoomListItemState extends State<RoomListItem> {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = widget.lengths % 3 == 0
        ? const Color.fromRGBO(185, 162, 249, 0.8)
        : const Color.fromRGBO(255, 223, 135, 1);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/home/info',
            arguments: widget.roomEntity);
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            // Текст в верхнем левом углу
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.roomEntity.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            // Картинка (если hasImage == false)
            if (!widget.roomEntity.isPublic)
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Image.asset('assets/lock.png'))),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:wishlist/feature/domain/entities/room_entity.dart';

// Widget RoomListItem(RoomEntity roomEntity) {
//   final Color bgColor = roomEntity.id % 2 == 0
//       ? const Color.fromRGBO(255, 223, 135, 1)
//       : const Color.fromRGBO(185, 162, 249, 0.8);
//   return GestureDetector(
//     onTap: () {
//       Navigator.pushNamed(context, '/home/info', arguments: widget.roomEntity);
//     },
//     child: Container(
//       decoration: BoxDecoration(
//         color: bgColor,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Stack(
//         children: [
//           // Текст в верхнем левом углу
//           Padding(
//             padding: const EdgeInsets.only(top: 20, left: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   roomEntity.name,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//               ],
//             ),
//           ),

//           // Картинка (если hasImage == false)
//           if (!roomEntity.isPublic)
//             Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                     padding: const EdgeInsets.only(left: 100),
//                     child: Image.asset('assets/lock.png'))),
//         ],
//       ),
//     ),
//   );
// }
