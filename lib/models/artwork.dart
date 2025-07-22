class ArtworkItem {
  final String id; // Thêm thuộc tính id
  final String title;
  final String artist;
  final String price;
  final String description; // Mô tả
  final String imagePath; //ảnh chính
  final String? material;
  final String? yearcreated; // Năm sáng tác (có thể để null nếu không có)
  final String? genre;
  final List<String> additionalImages; //danh sách ảnh phụ

  ArtworkItem({
    required this.id, // Thêm id vào constructor
    required this.title,
    required this.artist,
    required this.price,
    required this.description, // Mô tả
    required this.imagePath,
    required this.material,
    required this.genre,
    required this.yearcreated, // Năm sáng tác

    this.additionalImages = const [],
  });
  //getter lấy tất cả ảnh chính và phụ
  List<String> get allImages => [imagePath, ...additionalImages];
}

// Dữ liệu mẫu cho các tác phẩm nghệ thuật ở trang chủ
final List<ArtworkItem> artworks = [
  ArtworkItem(
    id: '1', // Thêm id cho mỗi item
    title: 'Flower in Oddy',
    artist: 'LT Nghiax',
    price: '200,000,000 VNĐ',
    material: '',
    yearcreated: '2023', // Năm sáng tác
    genre: 'Cổ điển',
    imagePath: 'assets/images/flowerstyle.jpg',
    description: '', // Mô tả mặc định là rỗng
    additionalImages: [
      'assets/images/flowerstyle.jpg',
      'assets/images/flowerstyle.jpg',
    ],
  ),
  ArtworkItem(
    id: '2',
    title: 'Think',
    artist: 'Doonstrij2',
    price: 'Price on request',
    material: '',
    yearcreated: '2023',
    genre: 'Hoa',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
    additionalImages: [
      'assets/images/flowerstyle.jpg',
      'assets/images/flowerstyle.jpg',
    ],
  ),
  ArtworkItem(
    id: '3',
    title: 'Old War',
    artist: 'Rune Quizzter',
    price: 'Price on request',
    material: '',
    yearcreated: '2023',
    genre: 'Hiện đại',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
    additionalImages: [
      'assets/images/flowerstyle.jpg',
      'assets/images/flowerstyle.jpg',
    ],
  ),
  ArtworkItem(
    id: '4',
    title: 'Blood Falls',
    artist: 'Doonstrij2',
    price: 'Price on request',
    material: '',
    yearcreated: '2023',
    genre: 'Hoa',
    description: 'A powerful piece depicting the struggles of war.',
    imagePath: 'assets/images/flowerstyle.jpg',
    additionalImages: [
      'assets/images/flowerstyle.jpg',
      'assets/images/flowerstyle.jpg',
    ],
  ),
];
