// lib/screens/main_screen.dart (hoặc navigation_screen.dart)
import 'package:app_ban_tranh_admin/models/user.dart';
import 'package:app_ban_tranh_admin/screens/account_screen.dart';
import 'package:app_ban_tranh_admin/screens/home_screen.dart';
import 'package:app_ban_tranh_admin/screens/ql_order_screen.dart';
import 'package:flutter/material.dart';

final User currentUser = User.sampleUser;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(user: currentUser),
    // const LiveScreen(),
    QlOrderScreen(user: currentUser),
    AccountScreen(user: currentUser),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang Chủ'),

          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Đơn Hàng',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá Nhân'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
