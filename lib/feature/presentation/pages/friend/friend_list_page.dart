import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
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
  @override
  Widget build(BuildContext context) {
    context
        .read<FriendCubit>()
        .fetchListFriends(Supabase.instance.client.auth.currentUser!.id);
    context
        .read<UserCubit>()
        .fetchUserInfo(Supabase.instance.client.auth.currentUser!.id);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          const Row(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Профиль',
                style: TextStyle(
                    color: Color.fromRGBO(109, 87, 252, 1), fontSize: 28),
              ),
            )
          ]),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Мои друзья',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    )),
                Text('Найти',
                    style: TextStyle(
                      color: Color.fromRGBO(109, 87, 252, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 0,
                    )),
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
