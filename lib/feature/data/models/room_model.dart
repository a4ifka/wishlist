import 'package:equatable/equatable.dart';
import '../../domain/entities/room_entity.dart';

class RoomModel extends RoomEntity with EquatableMixin {
  const RoomModel({
    required super.id,
    required super.name,
    super.isPublic = false,
    super.eventDate,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as int,
      name: json['name'] as String,
      isPublic: json['is_public'] as bool? ?? false,
      eventDate: json['event_date'] != null
          ? DateTime.tryParse(json['event_date'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_public': isPublic,
      if (eventDate != null)
        'event_date': eventDate!.toIso8601String().substring(0, 10),
    };
  }
}
