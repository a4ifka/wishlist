import 'package:equatable/equatable.dart';

class FriendEntity extends Equatable {
  final int id;
  final String senderId;
  final String receiverId;
  final String status;

  const FriendEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  @override
  List<Object?> get props => [id, senderId, receiverId, status];
}
