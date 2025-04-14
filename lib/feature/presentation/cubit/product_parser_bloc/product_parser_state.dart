part of 'product_parser_bloc.dart';

abstract class ProductParserState extends Equatable {
  const ProductParserState();

  @override
  List<Object> get props => [];
}

class ProductParserInitial extends ProductParserState {}

class ProductParserLoading extends ProductParserState {}

class ProductParserLoaded extends ProductParserState {
  final ProductEntity product;

  const ProductParserLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

class ProductParserError extends ProductParserState {
  final String message;

  const ProductParserError(this.message);

  @override
  List<Object> get props => [message];
}
