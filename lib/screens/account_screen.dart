// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:app_ban_tranh_admin/models/user.dart';

class AccountScreen extends StatefulWidget {
  final User user;

  const AccountScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo_art.png',
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              const Text(
                'Tài khoản cá nhân',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(children: [
         
        ],
      ),
    );
  }
}
