import 'package:equatable/equatable.dart';

class RoomEntity extends Equatable {
  final int id;
  final String name;
  final bool isPublic;
  final DateTime? eventDate;

  const RoomEntity({
    required this.id,
    required this.name,
    this.isPublic = false,
    this.eventDate,
  });

  @override
  List<Object?> get props => [id, name, isPublic, eventDate];
}
