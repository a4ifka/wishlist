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
      body: Column(
        children: [
          const SizedBox(height: 35),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Image.asset('assets/back.png'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
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
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          Expanded(child: Image.network(wishEntity.imageUrl)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 80,
                              margin: const EdgeInsets.only(
                                  left: 8, right: 4, bottom: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 223, 135, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  '₽ ${wishEntity.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 80,
                              margin: const EdgeInsets.only(
                                  left: 4, right: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(199, 181, 250, 1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset('assets/personpup.png')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Где можно приобрести',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 55),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(247, 247, 249, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(wishEntity.name,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(115, 115, 155, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  )),
                              Text(wishEntity.url,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  )),
                            ],
                          ),
                          Image.asset(
                            'assets/open.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(247, 247, 249, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(wishEntity.name,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(115, 115, 155, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  )),
                              Text(wishEntity.url2,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  )),
                            ],
                          ),
                          Image.asset(
                            'assets/open.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(247, 247, 249, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(wishEntity.name,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(115, 115, 155, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  )),
                              Text(wishEntity.url3,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  )),
                            ],
                          ),
                          Image.asset(
                            'assets/open.png',
                            height: 30,
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )

          // Column(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //         color: const Color.fromRGBO(155, 121, 246, 0.7),
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: Stack(
          //         children: [
          // Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Image.asset('assets/personpup.png')),
          //         ],
          //       ),
          //     ),
          //     Row(
          //       children: [
          //         Container(
          //           decoration: BoxDecoration(
          //             color: const Color.fromRGBO(155, 121, 246, 0.7),
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: Stack(
          //             children: [
          //               Align(
          //                   alignment: Alignment.bottomCenter,
          //                   child: Image.asset('assets/personpup.png')),
          //             ],
          //           ),
          //         ),
          //         Container(
          //           decoration: BoxDecoration(
          //             color: const Color.fromRGBO(155, 121, 246, 0.7),
          //             borderRadius: BorderRadius.circular(20),
          //           ),
          //           child: Stack(
          //             children: [
          //               Align(
          //                   alignment: Alignment.bottomCenter,
          //                   child: Image.asset('assets/personpup.png')),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
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