import 'package:equatable/equatable.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';

class ProductModel extends Equatable {
  final String article;
  final String? imageUrl;

  const ProductModel({
    required this.article,
    this.imageUrl,
  });

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      article: entity.article,
      imageUrl: entity.imageUrl,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      article: article,
      imageUrl: imageUrl,
    );
  }

  @override
  List<Object?> get props => [article, imageUrl];
}
