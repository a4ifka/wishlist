import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/marketplace_type.dart';
import 'package:wishlist/feature/domain/entities/product_entity.dart';
import 'package:wishlist/feature/domain/usecases/product/get_product.dart';

part 'product_parser_event.dart';
part 'product_parser_state.dart';

class ProductParserBloc extends Bloc<ProductParserEvent, ProductParserState> {
  final GetProduct getProduct;

  ProductParserBloc({required this.getProduct})
      : super(ProductParserInitial()) {
    on<FetchProductImageEvent>(_onFetchProductImage);
  }

  Future<void> _onFetchProductImage(
    FetchProductImageEvent event,
    Emitter<ProductParserState> emit,
  ) async {
    emit(ProductParserLoading());

    final isUrl = event.article.contains('://');
    final result = await getProduct(GetProductParams(
      input: event.article,
      marketplace: isUrl ? null : MarketplaceType.wildberries,
    ));

    result.fold(
      (failure) => emit(ProductParserError(_mapFailureToMessage(failure))),
      (product) => emit(ProductParserLoaded(product: product)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    return 'Unexpected error';
  }
}
