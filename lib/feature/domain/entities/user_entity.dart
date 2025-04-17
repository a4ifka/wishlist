import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/domain/entities/your_friend_entity.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String uuid;
  final List<YourFriendEntity>? friends;

  const UserEntity({
    required this.id,
    required this.name,
    required this.uuid,
    this.friends,
  });

  @override
  List<Object?> get props => [id, name, uuid, friends];
}
