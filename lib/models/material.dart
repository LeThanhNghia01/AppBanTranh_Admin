class Material {
  final String id;
  final String genreName;
  final String description;

  Material({
    required this.id,
    required this.genreName,
    required this.description,
  });
}

// Di chuyển homeGenres ra ngoài class để có thể truy cập từ bên ngoài
final List<Material> material = [
  Material(
    id: '1',
    genreName: 'Sơn dầu',
    description: 'Màu truyền thống, bền, đậm',
  ),
  Material(
    id: '2',
    genreName: 'Màu nước',
    description: 'Trong suốt, nhẹ nhàng',
  ),
  Material(
    id: '3',
    genreName: 'Bút chì',
    description: 'Phác họa, tranh trắng đen',
  ),
  Material(
    id: '4',
    genreName: 'Than chì',
    description: 'Đậm, mờ, dùng vẽ chân dung',
  ),
];
