part of 'product_parser_bloc.dart';

abstract class ProductParserEvent extends Equatable {
  const ProductParserEvent();

  @override
  List<Object> get props => [];
}

class FetchProductImageEvent extends ProductParserEvent {
  final String article;

  const FetchProductImageEvent(this.article);

  @override
  List<Object> get props => [article];
}
