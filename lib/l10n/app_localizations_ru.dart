// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

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
  @override
  String get restorePassword => 'Восстановить пароль';
  @override
  String get signInButton => 'Войти';
  @override
  String get createAccount => 'Создать аккаунт';
  @override
  String get authError => 'Ошибка аутентификации!';
  @override
  String get featureInDevelopment => 'В разработке';
  @override
  String get passwordHint => 'Придумайте пароль (не менее 8 символов)';
  @override
  String get passwordsMismatch => 'Пароли не совпадают!';
  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? Войдите';

  @override
  String get enterYourNickname => 'Введите свой ник';
  @override
  String get nickname => 'Ник';
  @override
  String get birthDateOptional => 'Дата рождения (необязательно)';
  @override
  String get notSpecified => 'Не указана';
  @override
  String get userNotAuthorized => 'Пользователь не авторизован';
  @override
  String get pleaseEnterNickname => 'Пожалуйста, введите ник';

  @override
  String get profile => 'Профиль';
  @override
  String get settings => 'Настройки';
  @override
  String get language => 'Язык';
  @override
  String get signOut => 'Выйти из аккаунта';
  @override
  String get birthDate => 'Дата рождения';

  @override
  String get home => 'Главная';
  @override
  String get greeting => 'Добрый день, ';
  @override
  String get myWishes => 'Мои желания';
  @override
  String get fulfilled => 'Исполнено';
  @override
  String get bookedByMe => 'Забронировано мной';
  @override
  String get myWishlists => 'Мои вишлисты';
  @override
  String get loading => 'Загрузка...';
  @override
  String get errorServer => 'Ошибка сервера';

  @override
  String get publicRoom => 'Публичная комната';
  @override
  String get publicRoomDesc => 'Видна всем пользователям';
  @override
  String get newWishlist => 'Новый вишлист';
  @override
  String get wishlistName => 'Название';
  @override
  String get eventDate => 'Дата праздника';
  @override
  String get add => 'Добавить';
  @override
  String get enterWishlistName => 'Введите название вишлиста';
  @override
  String get enterEventDate => 'Укажите дату праздника';

  @override
  String get share => 'Поделиться';
  @override
  String inviteText(String roomName, String url) =>
      'Посмотри мой вишлист «$roomName»!\n$url';
  @override
  String get noWishesYet => 'Список пока пуст';
  @override
  String get publicLabel => 'Публичный';
  @override
  String get privateLabel => 'Приватный';

  @override
  String get navHome => 'Главная';
  @override
  String get navFriends => 'Друзья';
  @override
  String get navProfile => 'Профиль';

  @override
  String get friends => 'Друзья';
  @override
  String get friendsWishlists => 'Вишлисты твоих друзей';
  @override
  String get findFriend => 'Найти друга';
  @override
  String get friendRequests => 'Заявки в друзья';
  @override
  String get myFriends => 'Мои друзья';
  @override
  String get today => 'Сегодня!';
  @override
  String get tomorrow => 'Завтра';
  @override
  String inNDays(int n) => 'Через $n дн.';
  @override
  String get viewAndBook => 'Смотреть и бронировать';
  @override
  String get feedEmpty => 'Пока тут пусто';
  @override
  String get addFriendsToSeeFeed => 'Добавь друзей, чтобы видеть их вишлисты';
  @override
  String get findFriends => 'Найти друзей';
  @override
  String get search => 'Поиск';
  @override
  String get enterUsername => 'Введите имя пользователя...';
  @override
  String get requestSent => 'Запрос отправлен';
  @override
  String get nobodyFound => 'Никого не нашли';
  @override
  String get tryAnotherName => 'Попробуй другое имя';
  @override
  String get startSearch => 'Начни поиск';
  @override
  String get enterUsernameAbove => 'Введи имя пользователя выше';
  @override
  String get incoming => 'Входящие';
  @override
  String get outgoing => 'Исходящие';
  @override
  String get responseSent => 'Ответ отправлен';
  @override
  String get requestCancelled => 'Запрос отменён';
  @override
  String get noIncomingRequests => 'Нет входящих заявок';
  @override
  String get noOutgoingRequests => 'Нет исходящих заявок';
  @override
  String get pending => 'Ожидание';
  @override
  String get emptyHere => 'Пока тут пусто';
  @override
  String friendRooms(String name) => 'Комнаты $name';
  @override
  String get success => 'Успешно';
  @override
  String get operationError => 'Ошибка';
  @override
  String get friendsHaventCreatedWishlists => 'Ваши друзья еще не создавали никаких списков желаний';
  @override
  String get noWishlistsFromFriends => 'Пока нет списков желаний';
  @override
  String get friendsWithWishlists => 'Друзья с вишлистами';
  @override
  String get friendsWithoutWishlists => 'Остальные друзья';
  @override
  String get noWishlistsYet => 'Пока нет вишлистов';
}