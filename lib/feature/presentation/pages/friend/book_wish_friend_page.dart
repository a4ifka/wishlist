import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishlist/feature/domain/entities/room_entity.dart';
import 'package:wishlist/feature/presentation/cubit/wish_cubit/wish_cubit.dart';
import 'package:wishlist/feature/presentation/widgets/book_wish_list_item.dart';

class BookWishFriendPage extends StatefulWidget {
  const BookWishFriendPage({super.key});

  @override
  State<BookWishFriendPage> createState() => _BookWishFriendPageState();
}

class _BookWishFriendPageState extends State<BookWishFriendPage> {
  @override
  Widget build(BuildContext context) {
    final roomEntity = ModalRoute.of(context)!.settings.arguments as RoomEntity;
    context.read<WishCubit>().fetchWishesByRoom(roomEntity.id);
    var listen = Supabase.instance.client
        .channel('public:wishes')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'wishes',
            callback: (payload) {
              context.read<WishCubit>().fetchWishesByRoom(roomEntity.id);
            })
        .subscribe();
    print('listen changes --> $listen');

    return Scaffold(
        appBar: AppBar(
          title: Text(roomEntity.name),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<WishCubit, WishState>(
                builder: (context, state) {
                  if (state is WishesLoaded) {
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
                        return BookWishListItem(product: state.wishes[index]);
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
            ),
            BlocListener<WishCubit, WishState>(
              listener: (context, state) {
                if (state is WishesSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Успешно '),
                      backgroundColor: Colors.greenAccent,
                    ),
                  );
                  context.read<WishCubit>().fetchWishesByRoom(roomEntity.id);
                } else if (state is WishError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ошибка '),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const SizedBox(),
            ),
          ],
        ));
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