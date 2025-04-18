import 'package:flutter/material.dart';
import 'package:wishlist/feature/domain/entities/wish_entity.dart';

class WishInfoPage extends StatefulWidget {
  const WishInfoPage({super.key});

  @override
  State<WishInfoPage> createState() => _WishInfoPageState();
}

class _WishInfoPageState extends State<WishInfoPage> {
  @override
  Widget build(BuildContext context) {
    final wishEntity = ModalRoute.of(context)!.settings.arguments as WishEntity;
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
              Text(
                wishEntity.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(109, 87, 252, 1),
                ),
              ),
            ],
          ),

          Column(
            children: [
              const SizedBox(height: 100),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/placeholder.png'),
                      image: NetworkImage(wishEntity.imageUrl),
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(Icons.broken_image,
                                color: Colors.grey[500]),
                          ),
                        );
                      },
                    ),
                  )),
              Row(
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      '₽ ${wishEntity.price.toStringAsFixed(2)} ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      child: Image.asset('assets/personpup.png')),
                ],
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       style: ElevatedButton.styleFrom(
          //         padding: const EdgeInsets.symmetric(vertical: 16),
          //         backgroundColor: const Color.fromRGBO(155, 121, 246, 1),
          //         foregroundColor: Colors.white,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(65),
          //         ),
          //       ),
          //       onPressed: () {
          //         Navigator.pushNamed(context, '/add-wish',
          //             arguments: roomEntity.id);
          //       },
          //       child: const Text(
          //         'Добавить',
          //         style: TextStyle(
          //           fontSize: 16, // Размер текста
          //           fontWeight: FontWeight.w600, // Жирность текста
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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