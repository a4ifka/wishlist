import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/add_wish_bottom_sheet.dart';
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
      // appBar: AppBar(
      //   title: Text(roomEntity.name),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/add-wish',
      //             arguments: roomEntity.id);
      //       },
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          const SizedBox(height: 45),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: IconButton(
                  icon: Image.asset('assets/back.png'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  roomEntity.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(109, 87, 252, 1),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<WishCubit, WishState>(
              builder: (context, state) {
                if (state is WishesLoaded) {
                  if (state.wishes.isEmpty) {
                    return const Center(child: Text('Вы ничего не добавили'));
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                  }
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: const Color.fromRGBO(155, 121, 246, 1),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(65),
                  ),
                ),
                onPressed: () {
                  showAddWishBottomSheet(context, roomEntity.id);
                },
                child: const Text(
                  'Добавить',
                  style: TextStyle(
                    fontSize: 16, // Размер текста
                    fontWeight: FontWeight.w600, // Жирность текста
                  ),
                ),
              ),
            ),
          ),
        ],
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