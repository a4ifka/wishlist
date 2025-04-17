import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/user_entity.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_cubit.dart';
import 'package:wishlist/feature/presentation/cubit/friend_cubit/friend_state.dart';
import 'package:wishlist/feature/presentation/widgets/friend_rooms_list_item.dart';

class FriendRoomsPage extends StatefulWidget {
  const FriendRoomsPage({super.key});

  @override
  State<FriendRoomsPage> createState() => _FriendRoomsPageState();
}

class _FriendRoomsPageState extends State<FriendRoomsPage> {
  @override
  Widget build(BuildContext context) {
    final userEntity = ModalRoute.of(context)!.settings.arguments as UserEntity;
    context.read<FriendCubit>().fetchFriendRooms(userEntity.uuid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Комнаты ${userEntity.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<FriendCubit, FriendState>(
              builder: (context, state) {
                if (state is FriendRoomsSuccess) {
                  return ListView.builder(
                      itemCount: state.room.length,
                      itemBuilder: (ctx, index) =>
                          FriendRoomsListItem(roomEntity: state.room[index]));
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
        ],
      ),
    );
  }
}
