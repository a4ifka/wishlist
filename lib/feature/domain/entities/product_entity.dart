import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String article;
  final String? imageUrl;

  const ProductEntity({
    required this.article,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [article, imageUrl];
}
