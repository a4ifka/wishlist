import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/room_cubit/room_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/pages/add_room_page.dart';
import 'package:wishlist/feature/presentation/pages/add_wish_page.dart';
import 'package:wishlist/feature/presentation/pages/auth/create_user_page.dart';
import 'package:wishlist/feature/presentation/pages/friend/book_wish_friend_page.dart';
import 'package:wishlist/feature/presentation/pages/friend/friend_list_page.dart';
import 'package:wishlist/feature/presentation/pages/friend/friend_request_page.dart';
import 'package:wishlist/feature/presentation/pages/friend/friend_rooms_page.dart';
import 'package:wishlist/feature/presentation/pages/friend/friend_search_page.dart';
import 'package:wishlist/feature/presentation/pages/home_page.dart';
import 'package:wishlist/feature/presentation/pages/invite_page.dart';
import 'package:wishlist/feature/presentation/pages/navigation_page.dart';
import 'package:wishlist/feature/presentation/pages/room_info_page.dart';
import 'package:wishlist/feature/presentation/pages/auth/sign_in_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/feature/presentation/pages/auth/sign_up_page.dart';
import 'package:wishlist/feature/presentation/pages/splash_page.dart';
import 'package:wishlist/feature/presentation/pages/wish_info_page.dart';
import 'package:wishlist/feature/presentation/cubit/locale_cubit/locale_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/product_cubit/product_cubit.dart';
import 'package:wishlist/local_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://jmbjjfpeotrikittygdt.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImptYmpqZnBlb3RyaWtpdHR5Z2R0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ0NTUzMDcsImV4cCI6MjA5MDAzMTMwN30.pJCKLgD6CzYUwuCd53vTbDwtH23FbP4vt4svFwnXGpY',
  );
  final savedLocale = await LocaleCubit.loadSaved();
  init();
  runApp(MainPage(initialLocale: savedLocale));
}

final supabase = Supabase.instance.client;

class MainPage extends StatefulWidget {
  final Locale initialLocale;
  const MainPage({super.key, required this.initialLocale});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Ссылка, которая открыла приложение (пока оно было закрыто)
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      // Ждём, пока NavigatorState будет готов
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleLink(initial));
    }

    // Ссылки пока приложение уже открыто
    _linkSub = _appLinks.uriLinkStream.listen(_handleLink);
  }

  void _handleLink(Uri uri) {
    if (uri.scheme == 'wishlist' && uri.host == 'invite') {
      final roomId = int.tryParse(uri.queryParameters['room'] ?? '');
      if (roomId != null) {
        navigatorKey.currentState?.pushNamed('/invite', arguments: roomId);
      }
    }
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(widget.initialLocale),
        ),
        BlocProvider<SignInUserCubit>(
          create: (context) => sl<SignInUserCubit>(),
        ),
        BlocProvider<SignUpUserCubit>(
          create: (context) => sl<SignUpUserCubit>(),
        ),
        BlocProvider<RoomCubit>(
          create: (context) => sl<RoomCubit>(),
        ),
        BlocProvider<WishCubit>(
          create: (context) => sl<WishCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => sl<UserCubit>(),
        ),
        BlocProvider<FriendCubit>(
          create: (context) => sl<FriendCubit>(),
        ),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          locale: locale,
          builder: (context, child) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: child,
          ),
          home: const SplashPage(),
          routes: {
            '/signIn': (context) => const SignInPage(),
            '/signUp': (context) => const SignUpPage(),
            '/create-user': (context) => const CreateUserPage(),
            '/home': (context) => const HomePage(),
            '/home/info': (context) => const RoomInfoPage(),
            '/home/wish': (context) => const WishInfoPage(),
            '/add-room': (context) => const AddRoomPage(),
            '/add-wish': (context) => BlocProvider<ProductCubit>(
                  create: (_) => sl<ProductCubit>(),
                  child: const AddWishPage(),
                ),
            '/navigation': (context) => const NavigationPage(),
            '/search-friend': (context) => FriendSearchPage(),
            '/request-friend': (context) => const FriendRequestPage(),
            '/list-friend': (context) => const FriendListPage(),
            '/rooms-friend': (context) => const FriendRoomsPage(),
            '/book-wishes': (context) => const BookWishFriendPage(),
            '/invite': (context) => const InvitePage(),
          },
          theme: ThemeData(
            fontFamily: 'Montserrat',
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru'),
            Locale('en'),
          ],
        ),
      ),
    );
  }
}
