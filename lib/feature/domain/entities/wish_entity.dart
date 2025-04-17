import 'package:equatable/equatable.dart';

class WishEntity extends Equatable {
  final int id;
  final int roomId;
  final String name;
  final String url;
  final String url2;
  final String url3;
  final double price;
  final String imageUrl;
  final bool isFulfilled;
  final String? fulfilledBy;

  const WishEntity({
    required this.id,
    required this.roomId,
    required this.name,
    required this.url,
    required this.url2,
    required this.url3,
    required this.price,
    required this.imageUrl,
    this.isFulfilled = false,
    this.fulfilledBy,
  });

  @override
  List<Object?> get props => [
        id,
        roomId,
        name,
        url,
        url2,
        url3,
        price,
        imageUrl,
        isFulfilled,
        fulfilledBy,
      ];
}
