/////////////
// lib/screens/ql_artist_screen.dart
import 'package:app_ban_tranh_admin/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh_admin/models/artist.dart';

class QlArtistScreen extends StatefulWidget {
  final User user;

  const QlArtistScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QlArtistScreen> createState() => _QlArtistScreenState();
}

class _QlArtistScreenState extends State<QlArtistScreen> {
  // Dữ liệu mẫu
  List<Artist> artists = [
    Artist(
      id: '1',
      artistname: 'LT Nghiax',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
    ),
    Artist(
      id: '2',
      artistname: 'Doonstrij2',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
    ),
    Artist(
      id: '3',
      artistname: 'Rune Quizzter',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
    ),
    Artist(
      id: '4',
      artistname: 'Minh Hoàng Artist',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
    ),
    Artist(
      id: '5',
      artistname: 'Văn Thành Painter',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
    ),
    Artist(
      id: '6',
      artistname: 'Nguyễn Thu Trang',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Artist> filteredArtists = [];

  @override
  void initState() {
    super.initState();
    filteredArtists = artists;
    _searchController.addListener(_filterArtists);
  }

  void _filterArtists() {
    setState(() {
      filteredArtists = artists
          .where(
            (artist) => artist.artistname.toLowerCase().contains(
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

  void _showAddArtistDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.person_add, color: Colors.blue),
              SizedBox(width: 8),
              Text('Thêm Tác Giả Mới'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên tác giả *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  _addArtist(nameController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void _addArtist(String name) {
    setState(() {
      artists.add(
        Artist(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          artistname: name,
          profilePictureUrl: 'assets/images/avAdmin.jpg',
        ),
      );
      _filterArtists();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Đã thêm tác giả "$name" thành công'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showEditArtistDialog(Artist artist) {
    final TextEditingController nameController = TextEditingController(
      text: artist.artistname,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 8),
              Text('Chỉnh Sửa Tác Giả'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên tác giả *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  _editArtist(artist, nameController.text.trim());
                  Navigator.pop(context);
                }
              },
              child: Text('Cập nhật'),
            ),
          ],
        );
      },
    );
  }

  void _editArtist(Artist oldArtist, String newName) {
    setState(() {
      int index = artists.indexWhere((a) => a.id == oldArtist.id);
      if (index != -1) {
        artists[index] = oldArtist.copyWith(artistname: newName);
      }
      _filterArtists();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Đã cập nhật thông tin tác giả thành công'),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showDeleteConfirmDialog(Artist artist) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 8),
              Text('Xác nhận xóa'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bạn có chắc chắn muốn xóa tác giả:'),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: artist.profilePictureUrl != null
                          ? AssetImage(artist.profilePictureUrl!)
                          : null,
                      child: artist.profilePictureUrl == null
                          ? Icon(Icons.person, size: 20)
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            artist.artistname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'ID: ${artist.id}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Hành động này không thể hoàn tác!',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteArtist(artist);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Xóa', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _deleteArtist(Artist artist) {
    // Store artist for undo functionality
    Artist deletedArtist = artist;
    int originalIndex = artists.indexOf(artist);

    setState(() {
      artists.removeWhere((a) => a.id == artist.id);
      _filterArtists();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('Đã xóa tác giả "${artist.artistname}"')),
          ],
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Hoàn tác',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              artists.insert(originalIndex, deletedArtist);
              _filterArtists();
            });
          },
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.grey.withOpacity(0.3),
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
                'Quản Lý Tác Giả',
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
          // Header with search and filters
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar and add button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 45,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm tác giả...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: _showAddArtistDialog,
                      icon: Icon(Icons.add, color: Colors.white),
                      label: Text(
                        'Thêm',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Statistics
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.grey[600], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Hiển thị: ${filteredArtists.length} / ${artists.length} tác giả',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Artist list
          Expanded(
            child: filteredArtists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchController.text.isEmpty
                              ? Icons.people_outline
                              : Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Chưa có tác giả nào'
                              : 'Không tìm thấy tác giả nào',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Nhấn nút "Thêm" để thêm tác giả mới'
                              : 'Thử tìm kiếm với từ khóa khác',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredArtists.length,
                    itemBuilder: (context, index) {
                      final artist = filteredArtists[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shadowColor: Colors.grey.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue.shade100,
                            backgroundImage: artist.profilePictureUrl != null
                                ? AssetImage(artist.profilePictureUrl!)
                                : null,
                            child: artist.profilePictureUrl == null
                                ? Icon(
                                    Icons.person,
                                    color: Colors.blue,
                                    size: 28,
                                  )
                                : null,
                          ),
                          title: Text(
                            artist.artistname,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'ID: ${artist.id}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              switch (value) {
                                case 'edit':
                                  _showEditArtistDialog(artist);
                                  break;
                                case 'delete':
                                  _showDeleteConfirmDialog(artist);
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text('Chỉnh sửa'),
                                  ],
                                ),
                              ),
                              PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Xóa',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
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
