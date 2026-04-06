import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/data/datasource/market_parsing/parsed_product.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';

class ProductModel extends Equatable {
  final String name;
  final double price;
  final String? imageUrl;

  const ProductModel({
    required this.name,
    required this.price,
    this.imageUrl,
  });

  factory ProductModel.fromParsed(ParsedProduct parsed) {
    return ProductModel(
      name: parsed.name,
      price: parsed.price,
      imageUrl: parsed.imageUrl,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(name: name, price: price, imageUrl: imageUrl);
  }

  @override
  List<Object?> get props => [name, price, imageUrl];
}
