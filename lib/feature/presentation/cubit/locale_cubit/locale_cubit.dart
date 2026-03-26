import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('ru'));

  void setRussian() => emit(const Locale('ru'));
  void setEnglish() => emit(const Locale('en'));
}
