import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String name;
  final double price;
  final String? imageUrl;

  const ProductEntity({
    required this.name,
    required this.price,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, price, imageUrl];
}
