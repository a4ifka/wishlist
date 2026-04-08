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

class MainPage extends StatelessWidget {
  final Locale initialLocale;
  const MainPage({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleCubit>(
          create: (context) => LocaleCubit(initialLocale),
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
        debugShowCheckedModeBanner: false,
        locale: locale,
        builder: (context, child) => GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: child,
        ),
        home: const SplashPage(),
        routes: {
          '/signIn': (context) => SignInPage(),
          '/signUp': (context) => SignUpPage(),
          '/create-user': (context) => CreateUserPage(),
          '/home': (context) => const HomePage(),
          '/home/info': (context) => RoomInfoPage(),
          '/home/wish': (context) => WishInfoPage(),
          '/add-room': (context) => const AddRoomPage(),
          '/add-wish': (context) => BlocProvider<ProductCubit>(
                create: (_) => sl<ProductCubit>(),
                child: const AddWishPage(),
              ),
          '/navigation': (context) => NavigationPage(),
          '/search-friend': (context) => FriendSearchPage(),
          '/request-friend': (context) => FriendRequestPage(),
          '/list-friend': (context) => FriendListPage(),
          '/rooms-friend': (context) => FriendRoomsPage(),
          '/book-wishes': (context) => BookWishFriendPage(),
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
