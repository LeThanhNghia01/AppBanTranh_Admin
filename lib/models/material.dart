class Material {
  final String id;
  final String materialName;
  final String description;

  Material({
    required this.id,
    required this.materialName,
    required this.description,
  });
}

// Di chuyển homeGenres ra ngoài class để có thể truy cập từ bên ngoài
final List<Material> material = [
  Material(
    id: '1',
    materialName: 'Sơn dầu',
    description: 'Màu truyền thống, bền, đậm',
  ),
  Material(
    id: '2',
    materialName: 'Màu nước',
    description: 'Trong suốt, nhẹ nhàng',
  ),
  Material(
    id: '3',
    materialName: 'Bút chì',
    description: 'Phác họa, tranh trắng đen',
  ),
  Material(
    id: '4',
    materialName: 'Than chì',
    description: 'Đậm, mờ, dùng vẽ chân dung',
  ),
];
