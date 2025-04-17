import 'package:flutter/material.dart';

import 'package:wishlist/feature/domain/entities/user_entity.dart';

class FriendListItem extends StatefulWidget {
  final UserEntity userEntity;
  const FriendListItem({super.key, required this.userEntity});

  @override
  State<FriendListItem> createState() => _FriendListItemState();
}

class _FriendListItemState extends State<FriendListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/rooms-friend',
            arguments: widget.userEntity);
      },
      child: ListTile(
        title: Text(
          widget.userEntity.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Image.asset(
          'assets/open.png',
          height: 30,
          width: 30,
        ),
      ),
    );
  }
}
