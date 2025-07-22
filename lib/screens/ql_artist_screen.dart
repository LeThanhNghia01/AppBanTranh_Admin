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
      isVerified: true,
    ),
    Artist(
      id: '2',
      artistname: 'Doonstrij2',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
      isVerified: true,
    ),
    Artist(
      id: '3',
      artistname: 'Rune Quizzter',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
      isVerified: false,
    ),
    Artist(
      id: '4',
      artistname: 'Minh Hoàng Artist',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
      isVerified: true,
    ),
    Artist(
      id: '5',
      artistname: 'Văn Thành Painter',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
      isVerified: true,
    ),
    Artist(
      id: '6',
      artistname: 'Nguyễn Thu Trang',
      profilePictureUrl: 'assets/images/avAdmin.jpg',
      isVerified: false,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Artist> filteredArtists = [];
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    filteredArtists = artists;
    _searchController.addListener(_filterArtists);
  }

  void _filterArtists() {
    setState(() {
      List<Artist> searchResults = artists
          .where(
            (artist) => artist.artistname.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ),
          )
          .toList();

      switch (_selectedFilter) {
        case 'verified':
          filteredArtists = searchResults
              .where((artist) => artist.isVerified)
              .toList();
          break;
        case 'unverified':
          filteredArtists = searchResults
              .where((artist) => !artist.isVerified)
              .toList();
          break;
        default:
          filteredArtists = searchResults;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddArtistDialog() {
    final TextEditingController nameController = TextEditingController();
    bool isVerified = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isVerified,
                        onChanged: (value) {
                          setState(() {
                            isVerified = value ?? true;
                          });
                        },
                      ),
                      Text('Tài khoản đã xác thực'),
                    ],
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
                      _addArtist(nameController.text.trim(), isVerified);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addArtist(String name, bool isVerified) {
    setState(() {
      artists.add(
        Artist(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          artistname: name,
          profilePictureUrl: 'assets/images/avAdmin.jpg',
          isVerified: isVerified,
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
    bool isVerified = artist.isVerified;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isVerified,
                        onChanged: (value) {
                          setState(() {
                            isVerified = value ?? true;
                          });
                        },
                      ),
                      Text('Tài khoản đã xác thực'),
                    ],
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
                      _editArtist(
                        artist,
                        nameController.text.trim(),
                        isVerified,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Cập nhật'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _editArtist(Artist oldArtist, String newName, bool isVerified) {
    setState(() {
      int index = artists.indexWhere((a) => a.id == oldArtist.id);
      if (index != -1) {
        artists[index] = oldArtist.copyWith(
          artistname: newName,
          isVerified: isVerified,
        );
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

  void _toggleVerification(Artist artist) {
    setState(() {
      int index = artists.indexWhere((a) => a.id == artist.id);
      if (index != -1) {
        artists[index] = artist.copyWith(isVerified: !artist.isVerified);
      }
      _filterArtists();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          artist.isVerified
              ? 'Đã hủy xác thực tác giả "${artist.artistname}"'
              : 'Đã xác thực tác giả "${artist.artistname}"',
        ),
        backgroundColor: artist.isVerified ? Colors.orange : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int verifiedCount = artists.where((a) => a.isVerified).length;
    int unverifiedCount = artists.length - verifiedCount;

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

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text('Tất cả (${artists.length})'),
                        selected: _selectedFilter == 'all',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'all';
                            _filterArtists();
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        label: Text('Đã xác thực ($verifiedCount)'),
                        selected: _selectedFilter == 'verified',
                        selectedColor: Colors.green.shade100,
                        checkmarkColor: Colors.green,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'verified';
                            _filterArtists();
                          });
                        },
                      ),
                      SizedBox(width: 8),
                      FilterChip(
                        label: Text('Chưa xác thực ($unverifiedCount)'),
                        selected: _selectedFilter == 'unverified',
                        selectedColor: Colors.orange.shade100,
                        checkmarkColor: Colors.orange,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'unverified';
                            _filterArtists();
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

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

                SizedBox(height: 12),

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
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.blue.shade100,
                                backgroundImage:
                                    artist.profilePictureUrl != null
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
                              if (artist.isVerified)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                            ],
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
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    artist.isVerified
                                        ? Icons.verified_user
                                        : Icons.pending,
                                    color: artist.isVerified
                                        ? Colors.green
                                        : Colors.orange,
                                    size: 16,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    artist.isVerified
                                        ? 'Đã xác thực'
                                        : 'Chưa xác thực',
                                    style: TextStyle(
                                      color: artist.isVerified
                                          ? Colors.green
                                          : Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ngày tạo: ${artist.createdAt?.day}/${artist.createdAt?.month}/${artist.createdAt?.year}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
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
                                case 'toggle_verify':
                                  _toggleVerification(artist);
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
                              PopupMenuItem<String>(
                                value: 'toggle_verify',
                                child: Row(
                                  children: [
                                    Icon(
                                      artist.isVerified
                                          ? Icons.cancel
                                          : Icons.verified_user,
                                      color: artist.isVerified
                                          ? Colors.orange
                                          : Colors.green,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      artist.isVerified
                                          ? 'Hủy xác thực'
                                          : 'Xác thực',
                                    ),
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
