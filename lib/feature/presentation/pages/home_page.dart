import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wishlist/feature/presentation/cubit/room_cubit/room_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/user_cubit/user_state.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/room_list_item.dart';
import 'package:wishlist/l10n/app_localizations.dart';
import 'package:wishlist/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RealtimeChannel? _roomsChannel;

  @override
  void initState() {
    super.initState();
    context.read<RoomCubit>().fetchRoomsByUser();
    context.read<UserCubit>().fetchUserInfo(supabase.auth.currentUser!.id);
    context.read<WishCubit>().fetchCounts();

    _roomsChannel = Supabase.instance.client
        .channel('public:rooms')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'rooms',
          callback: (_) => context.read<RoomCubit>().fetchRoomsByUser(),
        )
        .subscribe();
  }

  @override
  void dispose() {
    _roomsChannel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  l10n.home,
                  style: const TextStyle(
                      color: Color.fromRGBO(109, 87, 252, 1), fontSize: 28),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
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
                              fontSize: 24, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: l10n.greeting,
                              style: const TextStyle(color: Colors.black),
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
                      return Text(
                        l10n.loading,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w500,
                        ),
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
                  Expanded(
                    flex: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(155, 121, 246, 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  l10n.myWishes,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                BlocBuilder<WishCubit, WishState>(
                                  builder: (context, state) {
                                    final count = state is WishCountsLoaded
                                        ? state.myWishes
                                        : 0;
                                    return Text(
                                      count.toString(),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset('assets/person.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 20,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(158, 211, 126, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20, left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        l10n.fulfilled,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      BlocBuilder<WishCubit, WishState>(
                                        builder: (context, state) {
                                          final count =
                                              state is WishCountsLoaded
                                                  ? state.completed
                                                  : 0;
                                          return Text(
                                            count.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 80),
                                    child: Image.asset('assets/gift.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 163, 240, 1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 20, left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        l10n.bookedByMe,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      BlocBuilder<WishCubit, WishState>(
                                        builder: (context, state) {
                                          final count =
                                              state is WishCountsLoaded
                                                  ? state.myBooking
                                                  : 0;
                                          return Text(
                                            count.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: Image.asset('assets/lock.png'),
                                  ),
                                ),
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
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: '${l10n.myWishlists.split(' ').first} ',
                        style: const TextStyle(
                            color: Color.fromRGBO(109, 87, 252, 1)),
                      ),
                      TextSpan(
                        text: l10n.myWishlists.split(' ').skip(1).join(' '),
                        style: const TextStyle(color: Colors.black),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: state.rooms.length,
                      itemBuilder: (context, index) {
                        return RoomListItem(
                          roomEntity: state.rooms[index],
                          lengths: index,
                        );
                      },
                    ),
                  );
                } else if (state is RoomError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(
                    child: Text(
                      l10n.loading,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
