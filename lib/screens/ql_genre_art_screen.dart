// lib/screens/home_screen.dart
import 'package:app_ban_tranh_admin/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh_admin/models/genre.dart';

class QlGenreArtScreen extends StatefulWidget {
  final User user;

  const QlGenreArtScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QlGenreArtScreen> createState() => _QlGenreArtScreenState();
}

class _QlGenreArtScreenState extends State<QlGenreArtScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Hàm xóa thể loại
  void _deleteGenre(Genres genre) {
    _showDeleteConfirmDialog(genre);
  }

  // Hàm hiển thị dialog thêm thể loại mới
  void _showAddGenreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm thể loại mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tên thể loại',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Chọn ảnh từ thư viện
                },
                child: Text('Chọn ảnh'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Xử lý thêm thể loại
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Thêm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Hàm hiển thị options cho mỗi thể loại
  void _showGenreOptions(Genres genre) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context);
                  // Xử lý chỉnh sửa
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Xóa'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(genre);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm hiển thị dialog xác nhận xóa
  void _showDeleteConfirmDialog(Genres genre) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa thể loại "${genre.genreName}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                // Xử lý xóa thể loại
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã xóa thể loại "${genre.genreName}"'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
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
              SizedBox(width: 12),
              Text(
                'Quản Lý Thể Loại',
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
      body: Column(
        children: [
          // Phần chứa nút Back và nút Thêm Mới
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút Back
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, color: Colors.blue, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Quay lại',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Nút Thêm Mới
                ElevatedButton(
                  onPressed: _showAddGenreDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Thêm Mới',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Đường phân cách
          Divider(height: 1, color: Colors.grey[300], thickness: 1),
          // Phần GridView
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: homeGenres.length,
                itemBuilder: (context, index) {
                  final genre = homeGenres[index];
                  return GestureDetector(
                    onTap: () => _showGenreOptions(genre),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Background Image
                            Image.asset(
                              genre.ImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[600],
                                    size: 50,
                                  ),
                                );
                              },
                            ),
                            // Overlay gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.3),
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            // Genre Name
                            Positioned(
                              bottom: 16,
                              left: 16,
                              right: 16,
                              child: Text(
                                genre.genreName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withOpacity(0.8),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Delete icon ở góc trên phải
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => _deleteGenre(genre),
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
