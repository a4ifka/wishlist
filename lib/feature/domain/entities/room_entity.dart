import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final int id;
  final String name;
  final bool isPublic;
  final DateTime? eventDate;
  final int wishes;

  const RoomEntity({
    required this.id,
    required this.name,
    required this.wishes,
    this.isPublic = false,
    this.eventDate,

  });

  @override
  List<Object?> get props => [id, name, wishes, isPublic, eventDate];
}
