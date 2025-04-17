import 'package:equatable/equatable.dart';
import '../../domain/entities/wish_entity.dart';

class WishModel extends WishEntity with EquatableMixin {
  const WishModel({
    required super.id,
    required super.roomId,
    required super.name,
    required super.url,
    required super.price,
    required super.imageUrl,
    super.isFulfilled = false,
    super.fulfilledBy,
    required super.url2,
    required super.url3,
  });

  factory WishModel.fromJson(Map<String, dynamic> json) {
    return WishModel(
      id: json['id'] as int,
      roomId: json['room_id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
      url2: json['url2'] as String,
      url3: json['url3'] as String,
      price: json['price'] as double,
      imageUrl: json['image_url'] as String,
      isFulfilled: json['is_fulfilled'] as bool? ?? false,
      fulfilledBy: json['fulfilled_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'name': name,
      'url': url,
      'price': price,
      'image_url': imageUrl,
      'is_fulfilled': isFulfilled,
      'fulfilled_by': fulfilledBy,
    };
  }
}
