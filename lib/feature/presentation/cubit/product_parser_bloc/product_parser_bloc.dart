// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';
import 'package:wishlist/feature/domain/usecases/get_product_image.dart';

part 'product_parser_event.dart';
part 'product_parser_state.dart';

class ProductParserBloc extends Bloc<ProductParserEvent, ProductParserState> {
  final GetProductImage getProductImage;

  ProductParserBloc({required this.getProductImage})
      : super(ProductParserInitial()) {
    on<FetchProductImageEvent>(_onFetchProductImage);
  }

  Future<void> _onFetchProductImage(
    FetchProductImageEvent event,
    Emitter<ProductParserState> emit,
  ) async {
    emit(ProductParserLoading());

    final result = await getProductImage(event.article);

    result.fold(
      (failure) => emit(ProductParserError(_mapFailureToMessage(failure))),
      (product) => emit(ProductParserLoaded(product: product)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Server error';
      default:
        return 'Unexpected error';
    }
  }
}
