import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/domain/entities/your_friend_entity.dart';

class YourFriendModel extends YourFriendEntity with EquatableMixin {
  YourFriendModel(
      {required super.id, required super.uuid, required super.name});

  factory YourFriendModel.fromJson(Map<String, dynamic> json) {
    return YourFriendModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String,
      name: json['name'] as String,
    );
  }
}
