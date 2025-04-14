import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/data/models/your_friend_model.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';

class UserModel extends UserEntity with EquatableMixin {
  UserModel(
      {required super.id,
      required super.name,
      required super.uuid,
      super.friends});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] as int,
        name: json['name'] as String,
        uuid: json['uuid'] as String,
        friends: json['frineds'] as List<YourFriendModel>?);
  }
}
