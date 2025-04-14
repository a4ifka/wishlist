import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final int id;
  final String name;
  final bool isPublic;

  const RoomEntity({
    required this.id,
    required this.name,
    this.isPublic = false,
  });

  @override
  List<Object?> get props => [id, name, isPublic];
}
