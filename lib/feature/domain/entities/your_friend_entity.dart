import 'package:equatable/equatable.dart';

class YourFriendEntity extends Equatable {
  final int id;
  final String uuid;
  final String name;

  const YourFriendEntity(
      {required this.id, required this.uuid, required this.name});

  @override
  List<Object?> get props => [id, uuid, name];
}
