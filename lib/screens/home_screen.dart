// lib/screens/home_screen.dart

import 'package:app_ban_tranh_admin/models/user.dart';
import 'package:app_ban_tranh_admin/screens/ql_artist_screen.dart';
import 'package:app_ban_tranh_admin/screens/ql_artwork_screen.dart';
import 'package:app_ban_tranh_admin/screens/ql_genre_art_screen.dart';
import 'package:app_ban_tranh_admin/screens/ql_material_screen.dart';
import 'package:app_ban_tranh_admin/screens/ql_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh_admin/models/genre.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Museo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 2, // Tăng elevation để có shadow
        automaticallyImplyLeading:
            true, // Thay đổi thành true để hiển thị drawer icon
        iconTheme: IconThemeData(
          color: Colors.black,
        ), // Đặt màu cho drawer icon
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: 28,
            ), // Icon menu rõ ràng hơn
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Mở menu',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner có Welcome
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      'https://i.pinimg.com/736x/bf/15/cb/bf15cb08f7778fecf738659673d003fc.jpg',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          'Chào mừng ${widget.user.username}!',
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),

                  child: const Text(
                    'Quản Lý Thể Loại',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    // Tăng itemCount lên 1 để có chỗ cho nút quản lý
                    itemCount: homeGenres.length + 1,
                    itemBuilder: (context, index) {
                      // Item đầu tiên là nút quản lý thể loại
                      if (index == 0) {
                        return Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 16),
                          child: _buildManageGenreButton(context),
                        );
                      }

                      // Các item còn lại là thể loại (trừ 1 vì item đầu là nút quản lý)
                      final genre = homeGenres[index - 1];
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 16),
                        child: _buildGenreItem(genre, context),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            //Quản lý Admin
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/nenAdmin.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/images/avAdmin.jpg'),
                    ),
                  ),
                ),

                //button quản lý Admin
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Chuyển đến trang quản lý Admin
                        print('Chuyển đến trang quản lý Admin');
                        // Navigator.pushNamed(context, '/manage-admin');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Quản Lý Admin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Quản lý tác phẩm
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/nenartwork.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QlArtworkScreen(user: widget.user),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Quản Lý Tác Phẩm',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          //header drawer
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/nenAdmin.jpg'),
                ),
                SizedBox(height: 10),
                Text(
                  widget.user.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          //các mục trong drawer
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Trang chủ'),
            onTap: () {
              Navigator.pop(context); //đóng drawer
              //nếu đang ở trang home thì không làm gì
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Thông tin tác giả'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QlArtistScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Quản lý chất liệu'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QlMaterialScreen(user: widget.user),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Quản lý đơn hàng'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QlOrderScreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget để tạo nút quản lý thể loại
  Widget _buildManageGenreButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chuyển đến trang quản lý thể loại

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QlGenreArtScreen(user: widget.user),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/QLTL.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.palette, size: 60, color: Colors.white),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QlGenreArtScreen(user: widget.user),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Quản Lý Thể Loại',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget để hiển thị từng thể loại
  Widget _buildGenreItem(Genres genres, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Xử lý khi người dùng tap vào thể loại
        print('Tapped on ${genres.genreName}');
        // Navigator.pushNamed(context, '/genre', arguments: genre);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Hình ảnh nền
              Image.asset(
                genres.ImageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback nếu không load được ảnh
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
              ),
              // Overlay tối
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              ),
              // Text tên thể loại
              Positioned(
                top: 80,
                left: 16,
                right: 16,
                child: Text(
                  genres.genreName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
