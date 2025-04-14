import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/wish_list_item.dart';

class RoomInfoPage extends StatefulWidget {
  const RoomInfoPage({super.key});

  @override
  State<RoomInfoPage> createState() => _RoomInfoPageState();
}

class _RoomInfoPageState extends State<RoomInfoPage> {
  @override
  Widget build(BuildContext context) {
    final roomEntity = ModalRoute.of(context)!.settings.arguments as RoomEntity;
    context.read<WishCubit>().fetchWishesByRoom(roomEntity.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(roomEntity.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-wish',
                  arguments: roomEntity.id);
            },
          ),
        ],
      ),
      body: BlocBuilder<WishCubit, WishState>(
        builder: (context, state) {
          if (state is WishesLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: state.wishes.length,
              itemBuilder: (context, index) {
                return WishListItem(product: state.wishes[index]);
              },
            );
          } else if (state is WishError) {
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
    );
  }
}

      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
          // child: GridView.builder(
          //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 10,
          //     mainAxisSpacing: 10,
          //     childAspectRatio: 0.7,
          //   ),
          //   itemCount: products.length,
          //   itemBuilder: (context, index) {
          //     return WishListItem(product: products[index]);
          //   },
          // ),
      //   ),
      // ),