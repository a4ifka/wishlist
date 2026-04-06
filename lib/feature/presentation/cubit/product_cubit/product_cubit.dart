import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/marketplace_type.dart';
import 'package:wishlist/feature/domain/usecases/product/get_product.dart';
import 'package:wishlist/feature/presentation/cubit/product_cubit/product_state.dart';

export 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProduct getProduct;

  ProductCubit({required this.getProduct}) : super(ProductInitial());

  /// Парсит товар по полной ссылке (маркетплейс определяется автоматически).
  Future<void> parseByUrl(String url) async {
    emit(ProductLoading());
    final result = await getProduct(GetProductParams(input: url));
    emit(result.fold(
      (failure) => ProductError(message: _message(failure)),
      (product) => ProductLoaded(product: product),
    ));
  }

  /// Парсит товар по артикулу для выбранного маркетплейса.
  Future<void> parseByArticle(String article, MarketplaceType marketplace) async {
    emit(ProductLoading());
    final result = await getProduct(
      GetProductParams(input: article, marketplace: marketplace),
    );
    emit(result.fold(
      (failure) => ProductError(message: _message(failure)),
      (product) => ProductLoaded(product: product),
    ));
  }

  void reset() => emit(ProductInitial());

  String _message(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    return 'Неизвестная ошибка';
  }
}
