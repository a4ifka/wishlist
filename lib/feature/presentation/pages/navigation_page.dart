import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wishlist/feature/presentation/pages/add_room_page.dart';
import 'package:wishlist/feature/presentation/pages/friend/friend_search_page.dart';
import 'package:wishlist/feature/presentation/pages/home_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;

  // Список экранов для переключения
  final List<Widget> _screens = [
    const HomePage(),
    const AddRoomPage(),
    FriendSearchPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Обновляем текущий выбранный индекс
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Добавить',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Друзья',
          ),
        ],
        currentIndex: _selectedIndex, // Устанавливаем текущий индекс
        selectedItemColor: Colors.green,
        onTap: _onItemTapped, // Обработка нажатия
      ),
    );
  }
}
