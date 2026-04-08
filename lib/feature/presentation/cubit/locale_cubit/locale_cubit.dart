import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _key = 'locale';

  LocaleCubit(Locale initial) : super(initial);

  static Future<Locale> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == 'en') return const Locale('en');
    return const Locale('ru');
  }

  Future<void> setRussian() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, 'ru');
    emit(const Locale('ru'));
  }

  Future<void> setEnglish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, 'en');
    emit(const Locale('en'));
  }
}
