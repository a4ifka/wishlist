import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
import 'package:wishlist/feature/presentation/cubit/locale_cubit/locale_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';
import 'package:wishlist/feature/presentation/widgets/friend_list_item.dart';
import 'package:wishlist/main.dart';

class FriendListPage extends StatefulWidget {
  const FriendListPage({super.key});

  @override
  State<FriendListPage> createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  RealtimeChannel? _friendsChannel;

  @override
  void initState() {
    super.initState();
    final userId = supabase.auth.currentUser!.id;
    context.read<FriendCubit>().fetchListFriends(userId);
    context.read<UserCubit>().fetchUserInfo(userId);
    _friendsChannel = Supabase.instance.client
        .channel('friend_list:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'friend_requset',
          callback: (_) => context.read<FriendCubit>().fetchListFriends(userId),
        )
        .subscribe();
  }

  @override
  void dispose() {
    _friendsChannel?.unsubscribe();
    super.dispose();
  }

  void _showSettings(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return BlocProvider.value(
          value: localeCubit,
          child: BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              final isRu = locale.languageCode == 'ru';
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Настройки',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D57FC),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Язык',
                      style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                context.read<LocaleCubit>().setRussian(),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: isRu
                                    ? const Color(0xFF6D57FC)
                                    : const Color(0xFFF6F5F8),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFF9B79F6),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Русский',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isRu ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                context.read<LocaleCubit>().setEnglish(),
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: !isRu
                                    ? const Color(0xFF6D57FC)
                                    : const Color(0xFFF6F5F8),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: const Color(0xFF9B79F6),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: !isRu ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await supabase.auth.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/signIn',
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          'Выйти из аккаунта',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Профиль',
                  style: TextStyle(
                      color: Color.fromRGBO(109, 87, 252, 1), fontSize: 28),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined,
                      color: Color.fromRGBO(109, 87, 252, 1), size: 28),
                  onPressed: () => _showSettings(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(199, 181, 250, 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 14.5, bottom: 14.5),
                    child: Container(
                      width: 105,
                      height: 105,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 234, 223, 1),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/avatar.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, state) {
                            if (state is UserLoaded) {
                              return Text(
                                state.users.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            } else if (state is UserError) {
                              return Center(child: Text(state.message));
                            } else {
                              return const Center(
                                child: Text('Загрузка...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                    )),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 4),
                        Text(
                          supabase.auth.currentSession!.user.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Мои друзья',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    )),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search-friend');
                  },
                  child: const Text('Найти',
                      style: TextStyle(
                        color: Color.fromRGBO(109, 87, 252, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: BlocBuilder<FriendCubit, FriendState>(
                builder: (context, state) {
                  if (state is FriendListSuccess) {
                    return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (ctx, index) =>
                            FriendListItem(userEntity: state.users[index]));
                  } else if (state is FriendError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(
                      child: Text('Загрузка...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          )),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
