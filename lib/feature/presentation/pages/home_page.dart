import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wishlist/feature/presentation/cubit/room_cubit/room_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/add_room_bottom_sheet.dart';

import 'package:wishlist/feature/presentation/widgets/room_list_item.dart';
import 'package:wishlist/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<RoomCubit>().fetchRoomsByUser();
  }

  @override
  Widget build(BuildContext context) {
    context.read<RoomCubit>().fetchRoomsByUser();

    context.read<UserCubit>().fetchUserInfo(supabase.auth.currentUser!.id);
    context.read<WishCubit>().fetchCompleted(0);
    context.read<WishCubit>().fetchMyBooking(0);
    var listen = Supabase.instance.client
        .channel('public:rooms')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'rooms',
            callback: (payload) {
              context.read<RoomCubit>().fetchRoomsByUser();
              print('callback');
            })
        .subscribe();
    print('listen changes --> $listen');
    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showAddRoomBottomSheet(context);
            },
          ),
        ],
      ),
      body: Column(children: [
        const SizedBox(height: 35),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  if (state is UserLoaded) {
                    return RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Добрый день, ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: state.users.name,
                            style: const TextStyle(
                                color: Color.fromRGBO(109, 87, 252, 1)),
                          ),
                        ],
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
            ),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Большой левый блок
                Expanded(
                  flex: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(155, 121, 246, 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // Текст в верхнем левом углу
                        const Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Мои желания',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                '10',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Картинка внизу
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset('assets/person.png')),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Правые блоки (два по вертикали)
                Expanded(
                  flex: 20,
                  child: Column(
                    children: [
                      // Верхний правый блок
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(158, 211, 126, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              // Текст в верхнем левом углу
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Исполнено',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    BlocBuilder<WishCubit, WishState>(
                                      builder: (context, state) {
                                        if (state is WishesGetCountCompleted) {
                                          return Text(
                                            state.count.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else if (state is WishError) {
                                          return Center(
                                              child: Text(state.message));
                                        } else {
                                          return const Text(
                                            '0',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Картинка в правом нижнем углу
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 80),
                                      child: Image.asset('assets/gift.png'))),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Нижний правый блок
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 163, 240, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              // Текст в верхнем левом углу
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Забронировано \n мной',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    BlocBuilder<WishCubit, WishState>(
                                      builder: (context, state) {
                                        if (state is WishesGetCountBooking) {
                                          return Text(
                                            state.count.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        } else if (state is WishError) {
                                          return Center(
                                              child: Text(state.message));
                                        } else {
                                          return const Text(
                                            '0',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              // Картинка в правом нижнем углу
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: Image.asset('assets/lock.png'))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: 'Мои ',
                      style: TextStyle(color: Color.fromRGBO(109, 87, 252, 1)),
                    ),
                    TextSpan(
                      text: 'вишлисты',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          child: BlocBuilder<RoomCubit, RoomState>(
            builder: (context, state) {
              if (state is RoomsLoaded) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 колонки
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: 1.4, // Соотношение сторон элементов
                    ),
                    itemCount: state.rooms.length,
                    itemBuilder: (context, index) {
                      return RoomListItem(roomEntity: state.rooms[index]);
                    },
                  ),
                );
                // return ListView.builder(
                //     itemCount: state.rooms.length,
                //     itemBuilder: (ctx, index) =>
                //         RoomListItem(state.rooms[index]));
              } else if (state is RoomError) {
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
      ]),
    );
  }
}
