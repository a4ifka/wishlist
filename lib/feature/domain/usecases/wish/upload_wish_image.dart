import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist/core/error/failure.dart';
import 'package:wishlist/core/usecases/usecase.dart';
import 'package:wishlist/feature/domain/repositories/wish_repository.dart';

class UploadWishImage implements UseCase<String, UploadWishImageParams> {
  final WishRepository repository;

  UploadWishImage({required this.repository});

  @override
  Future<Either<Failure, String>> call(UploadWishImageParams params) async {
    return await repository.uploadWishImage(params.bytes, params.fileName);
  }
}

class UploadWishImageParams extends Equatable {
  final Uint8List bytes;
  final String fileName;

  const UploadWishImageParams({required this.bytes, required this.fileName});

  @override
  List<Object?> get props => [fileName];
}
