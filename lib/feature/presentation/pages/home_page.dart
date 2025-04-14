import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/presentation/cubit/room_cubit/room_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/room_list_item.dart';

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
        title: const Text('Мои комнаты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-room');
            },
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: BlocBuilder<RoomCubit, RoomState>(
            builder: (context, state) {
              if (state is RoomsLoaded) {
                return ListView.builder(
                    itemCount: state.rooms.length,
                    itemBuilder: (ctx, index) =>
                        RoomListItem(roomEntity: state.rooms[index]));
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
