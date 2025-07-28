import 'package:app_ban_tranh_admin/models/admins.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh_admin/models/user.dart';

class QlAcAdminScreen extends StatefulWidget {
  final User user;

  const QlAcAdminScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QlAcAdminScreen> createState() => _QlAcAdminScreenState();
}

class _QlAcAdminScreenState extends State<QlAcAdminScreen> {
  List<Admins> admins = [
    Admins(
      id: '1',
      adminname: 'LT Nghiax',
      password: '123',
      email: 'nghia@example.com',
      phone: '0909123456',
    ),
    Admins(
      id: '2',
      adminname: 'Doonstrij2',
      password: 'abc',
      email: 'doon@example.com',
      phone: '0909876543',
    ),
    Admins(
      id: '3',
      adminname: 'Rune Quizzter',
      password: 'pass123',
      email: 'rune@example.com',
      phone: '0901111222',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Admins> filteredAdmins = [];

  @override
  void initState() {
    super.initState();
    filteredAdmins = admins;
    _searchController.addListener(_filterAdmins);
  }

  void _filterAdmins() {
    setState(() {
      filteredAdmins = admins
          .where(
            (admin) =>
                admin.adminname.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ) ||
                admin.email.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quản lý Admin')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm theo tên hoặc email',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredAdmins.length,
              itemBuilder: (context, index) {
                final admin = filteredAdmins[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade200,
                      child: Text(admin.adminname[0]),
                    ),
                    title: Text(admin.adminname),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${admin.id}'),
                        Text('Email: ${admin.email}'),
                        Text('SĐT: ${admin.phone}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
