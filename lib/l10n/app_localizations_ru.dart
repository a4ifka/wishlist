// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get login => 'Вход';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get reppassword => 'Повтор пароля';

  @override
  String get register => 'Регистрация';

  @override
  String get next => 'Продолжить';
}
