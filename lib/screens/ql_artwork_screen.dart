// lib/screens/home_screen.dart
import 'dart:io';
import 'package:app_ban_tranh_admin/models/user.dart';
import 'package:flutter/material.dart';
import 'package:app_ban_tranh_admin/models/artwork.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class QlArtworkScreen extends StatefulWidget {
  final User user;

  const QlArtworkScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<QlArtworkScreen> createState() => _QlArtworkScreenState();
}

class _QlArtworkScreenState extends State<QlArtworkScreen> {
  File? imagePath;
  List<File> additionalImages = [];
  //kiểm tra xem có tích vào box phân loại sản phẩm k
  bool isSPThuong = false;
  bool isSPDauGia = false;
  // Dữ liệu mẫu từ các bảng khác
  List<String> artists = [
    'LT Nghiax',
    'Doonstrij2',
    'Minh Hoàng Artist',
    'Văn Thành Painter',
  ];
  List<String> materials = ['Sơn dầu', 'Lụa', 'Gốm', 'Đồng', 'Gỗ', 'Giấy'];
  List<String> categories = [
    'Tranh phong cảnh',
    'Tranh chân dung',
    'Tranh trừu tượng',
    'Tranh tĩnh vật',
  ];

  String? selectedArtist;
  String? selectedMaterial;
  String? selectedCategory;

  // Hàm xóa tác phẩm
  void _deleteArtwork(ArtworkItem artwork) {
    _showDeleteConfirmDialog(artwork);
  }

  //hàm thêm ảnh chính từ thư viện
  Future<void> _pickMainImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imagePath = File(pickedFile.path);
      });
    }
  }

  //hàm chọn nhiều ảnh phụ
  Future<void> _pickAdditionalImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        additionalImages = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  // Hàm hiển thị dialog thêm tác phẩm mới
  void _showAddArtworkDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController yearController = TextEditingController();

    // Tạo biến local cho dialog thay vì dùng biến class
    File? localImagePath;
    List<File> localAdditionalImages = [];

    selectedArtist = null;
    selectedMaterial = null;
    selectedCategory = null;
    isSPThuong = false;
    isSPDauGia = false;

    // Hàm chọn ảnh chính local
    Future<void> pickMainImageLocal(StateSetter setDialogState) async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setDialogState(() {
          localImagePath = File(pickedFile.path);
        });
      }
    }

    // Hàm chọn ảnh phụ local
    Future<void> pickAdditionalImageLocal(StateSetter setDialogState) async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );
      if (result != null) {
        setDialogState(() {
          localAdditionalImages = result.paths
              .map((path) => File(path!))
              .toList();
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Thêm tác phẩm mới'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Phần phân loại sản phẩm
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phân loại sản phẩm',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setDialogState(() {
                                        isSPThuong = !isSPThuong;
                                        if (isSPThuong) isSPDauGia = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSPThuong
                                            ? Colors.green[50]
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSPThuong
                                              ? Colors.green
                                              : Colors.grey[300]!,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: isSPThuong
                                                  ? Colors.green
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: isSPThuong
                                                    ? Colors.green
                                                    : Colors.grey[400]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: isSPThuong
                                                ? Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Sản phẩm thường',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: isSPThuong
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: isSPThuong
                                                    ? Colors.green[700]
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setDialogState(() {
                                        isSPDauGia = !isSPDauGia;
                                        if (isSPDauGia) isSPThuong = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isSPDauGia
                                            ? Colors.orange[50]
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSPDauGia
                                              ? Colors.orange
                                              : Colors.grey[300]!,
                                          width: 2,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: isSPDauGia
                                                  ? Colors.orange
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: isSPDauGia
                                                    ? Colors.orange
                                                    : Colors.grey[400]!,
                                                width: 2,
                                              ),
                                            ),
                                            child: isSPDauGia
                                                ? Icon(
                                                    Icons.check,
                                                    size: 14,
                                                    color: Colors.white,
                                                  )
                                                : null,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Sản phẩm đấu giá',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: isSPDauGia
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: isSPDauGia
                                                    ? Colors.orange[700]
                                                    : Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Các trường thông tin khác
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Tên tác phẩm',
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedArtist,
                        decoration: InputDecoration(
                          labelText: 'Nghệ sĩ',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        items: artists.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setDialogState(() {
                            selectedArtist = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Vui lòng chọn nghệ sĩ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Giá',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedMaterial,
                        decoration: InputDecoration(
                          labelText: 'Chất liệu',
                          prefixIcon: Icon(Icons.brush),
                          border: OutlineInputBorder(),
                        ),
                        items: materials.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setDialogState(() {
                            selectedMaterial = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: yearController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Năm sáng tác',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          labelText: 'Thể loại',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setDialogState(() {
                            selectedCategory = newValue;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Mô tả',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Phần chọn ảnh chính - ĐÃ SỬA
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ảnh chính',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          // Hiển thị preview ảnh chính nếu đã chọn
                          if (localImagePath != null)
                            Container(
                              height: 120,
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  localImagePath!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () => pickMainImageLocal(setDialogState),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.grey[800],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.image, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  localImagePath == null
                                      ? 'Chọn ảnh chính'
                                      : 'Thay đổi ảnh chính',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Phần chọn ảnh phụ - ĐÃ SỬA
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ảnh phụ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          // Hiển thị danh sách preview ảnh phụ nếu có
                          if (localAdditionalImages.isNotEmpty)
                            Container(
                              height: 100,
                              margin: EdgeInsets.only(bottom: 8),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: localAdditionalImages.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 100,
                                    margin: EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.file(
                                            localAdditionalImages[index],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                        // Nút xóa ảnh
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              setDialogState(() {
                                                localAdditionalImages.removeAt(
                                                  index,
                                                );
                                              });
                                            },
                                            child: Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () =>
                                pickAdditionalImageLocal(setDialogState),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.grey[800],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.collections, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  localAdditionalImages.isEmpty
                                      ? 'Chọn ảnh phụ'
                                      : 'Thêm ảnh phụ',
                                ),
                              ],
                            ),
                          ),
                          if (localAdditionalImages.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Đã chọn ${localAdditionalImages.length} ảnh',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                    if (titleController.text.trim().isEmpty ||
                        selectedArtist == null ||
                        priceController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Vui lòng điền đầy đủ thông tin bắt buộc',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Kiểm tra nếu là sản phẩm thường thì phải có ảnh chính
                    if (isSPThuong && localImagePath == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Vui lòng chọn ảnh chính cho sản phẩm'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Cập nhật ảnh vào biến class nếu cần
                    setState(() {
                      imagePath = localImagePath;
                      additionalImages = localAdditionalImages;
                    });

                    // Xử lý thêm tác phẩm với ảnh
                    // TODO: Thêm logic upload ảnh lên server ở đây

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã thêm tác phẩm "${titleController.text}"',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Thêm', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showFilterArtworkDialog() {}
  // Hàm hiển thị options cho mỗi tác phẩm
  void _showArtworkOptions(ArtworkItem artwork) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.visibility, color: Colors.green),
                title: Text('Xem chi tiết'),
                onTap: () {
                  Navigator.pop(context);
                  _showArtworkDetail(artwork);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Chỉnh sửa'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditArtworkDialog(artwork);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Xóa'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmDialog(artwork);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm hiển thị chi tiết tác phẩm với gallery ảnh
  void _showArtworkDetail(ArtworkItem artwork) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chi tiết tác phẩm',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gallery ảnh
                        Container(
                          height: 250,
                          child: PageView.builder(
                            itemCount: artwork.allImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    artwork.allImages[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        // Thông tin tác phẩm
                        Text(
                          artwork.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          artwork.artist,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          artwork.price,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildInfoRow(
                          'Chất liệu:',
                          artwork.material ?? 'Không có',
                        ),
                        _buildInfoRow(
                          'Năm sáng tác:',
                          artwork.yearcreated ?? 'Không có',
                        ),
                        _buildInfoRow('Thể loại:', artwork.genre ?? 'Không có'),
                        SizedBox(height: 16),
                        Text(
                          'Mô tả:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          artwork.description.isNotEmpty
                              ? artwork.description
                              : 'Không có mô tả',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(child: Text(value, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  // Hàm hiển thị dialog chỉnh sửa tác phẩm
  void _showEditArtworkDialog(ArtworkItem artwork) {
    final TextEditingController titleController = TextEditingController(
      text: artwork.title,
    );
    final TextEditingController priceController = TextEditingController(
      text: artwork.price,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: artwork.description,
    );
    final TextEditingController yearController = TextEditingController(
      text: artwork.yearcreated,
    );
    isSPDauGia = artwork.isSPDauGia ?? false;
    isSPThuong = artwork.isSPThuong ?? false;
    selectedArtist = artwork.artist;
    selectedMaterial = artwork.material;
    selectedCategory = artwork.genre;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Chỉnh sửa tác phẩm'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Tên tác phẩm',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedArtist,
                      decoration: InputDecoration(
                        labelText: 'Nghệ sĩ',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      items: artists.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedArtist = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Giá',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedMaterial,
                      decoration: InputDecoration(
                        labelText: 'Chất liệu',
                        prefixIcon: Icon(Icons.brush),
                        border: OutlineInputBorder(),
                      ),
                      items: materials.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMaterial = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: yearController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Năm sáng tác',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Thể loại',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Mô tả',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text('Sản phẩm thưởng'),
                            value: isSPThuong,
                            onChanged: (bool? value) {
                              setState(() {
                                isSPThuong = value ?? false;
                                if (isSPThuong) isSPDauGia = false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: Text('Sản phẩm đấu giá'),
                            value: isSPDauGia,
                            onChanged: (bool? value) {
                              setState(() {
                                isSPDauGia = value ?? false;
                                if (isSPDauGia) isSPThuong = false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                    if (titleController.text.trim().isEmpty ||
                        selectedArtist == null ||
                        priceController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Vui lòng điền đầy đủ thông tin bắt buộc',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Xử lý cập nhật tác phẩm
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Đã cập nhật tác phẩm "${titleController.text}"',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    'Cập nhật',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Hàm hiển thị dialog xác nhận xóa
  void _showDeleteConfirmDialog(ArtworkItem artwork) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text(
            'Bạn có chắc chắn muốn xóa tác phẩm "${artwork.title}" không?',
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
                // Xử lý xóa tác phẩm
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xóa tác phẩm "${artwork.title}"')),
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
                'Quản Lý Tác Phẩm',
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
                Row(
                  children: [
                    //Nút lọc
                    ElevatedButton(
                      onPressed: _showFilterArtworkDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          159,
                          233,
                          243,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        'Lọc',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Nút Thêm Mới
                    ElevatedButton(
                      onPressed: _showAddArtworkDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
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
              ],
            ),
          ),
          // Đường phân cách
          Divider(height: 1, color: Colors.grey[300], thickness: 1),

          // Phần ListView hiển thị các tác phẩm
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: artworks.length,
              itemBuilder: (context, index) {
                final artwork = artworks[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Ảnh tác phẩm - có thể bấm để xem gallery
                        GestureDetector(
                          onTap: () => _showArtworkDetail(artwork),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    artwork.imagePath,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80,
                                        height: 80,
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                  // Hiển thị số lượng ảnh nếu có nhiều hơn 1
                                  if (artwork.allImages.length > 1)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          '${artwork.allImages.length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        // Thông tin tác phẩm
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artwork.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                artwork.artist,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              if (artwork.yearcreated != null)
                                Text(
                                  'Năm ${artwork.yearcreated}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              SizedBox(height: 4),
                              if (artwork.material != null &&
                                  artwork.material!.isNotEmpty)
                                Text(
                                  artwork.material!,
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              SizedBox(height: 8),
                              Text(
                                artwork.price,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Nút actions
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => _showArtworkOptions(artwork),
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey[600],
                              ),
                              iconSize: 20,
                            ),
                            IconButton(
                              onPressed: () => _deleteArtwork(artwork),
                              icon: Icon(Icons.delete, color: Colors.red),
                              iconSize: 20,
                            ),
                          ],
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
