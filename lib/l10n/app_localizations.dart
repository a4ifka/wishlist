import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  // --- Auth ---
  String get login;
  String get email;
  String get password;
  String get reppassword;
  String get register;
  String get next;
  String get restorePassword;
  String get signInButton;
  String get createAccount;
  String get authError;
  String get featureInDevelopment;
  String get passwordHint;
  String get passwordsMismatch;
  String get alreadyHaveAccount;

  // --- Create user ---
  String get enterYourNickname;
  String get nickname;
  String get birthDateOptional;
  String get notSpecified;
  String get userNotAuthorized;
  String get pleaseEnterNickname;

  // --- Profile ---
  String get profile;
  String get settings;
  String get language;
  String get signOut;
  String get birthDate;

  // --- Home ---
  String get home;
  String get greeting;
  String get myWishes;
  String get fulfilled;
  String get bookedByMe;
  String get myWishlists;
  String get loading;
  String get errorServer;

  // --- Wishlist ---
  String get publicRoom;
  String get publicRoomDesc;
  String get newWishlist;
  String get wishlistName;
  String get eventDate;
  String get add;
  String get enterWishlistName;
  String get enterEventDate;

  // --- Share / Invite ---
  String get share;
  String inviteText(String roomName, String url);
  String get noWishesYet;
  String get publicLabel;
  String get privateLabel;

  // --- Navigation ---
  String get navHome;
  String get navFriends;
  String get navProfile;

  // --- Friends ---
  String get friends;
  String get friendsWishlists;
  String get findFriend;
  String get friendRequests;
  String get myFriends;
  String get today;
  String get tomorrow;
  String inNDays(int n);
  String get viewAndBook;
  String get feedEmpty;
  String get addFriendsToSeeFeed;
  String get findFriends;
  String get search;
  String get enterUsername;
  String get requestSent;
  String get nobodyFound;
  String get tryAnotherName;
  String get startSearch;
  String get enterUsernameAbove;
  String get incoming;
  String get outgoing;
  String get responseSent;
  String get requestCancelled;
  String get noIncomingRequests;
  String get noOutgoingRequests;
  String get pending;
  String get emptyHere;
  String friendRooms(String name);
  String get success;
  String get operationError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }
  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale".');
}
