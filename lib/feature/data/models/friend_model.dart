import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/domain/entities/friend_entity.dart';

class FriendModel extends FriendEntity with EquatableMixin {
  FriendModel(
      {required super.id,
      required super.senderId,
      required super.receiverId,
      required super.status});

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] as int,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      status: json['status'] as String,
    );
  }
}
