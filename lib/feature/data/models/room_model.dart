import 'package:equatable/equatable.dart';
import '../../domain/entities/room_entity.dart';

class RoomModel extends RoomEntity with EquatableMixin {
  const RoomModel({
    required super.id,
    required super.name,
    super.isPublic = false,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as int,
      name: json['name'] as String,
      isPublic: json['is_public'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_public': isPublic,
    };
  }
}
