class Genres {
  final String id;
  final String genreName;
  final String ImageUrl;

  Genres({required this.id, required this.genreName, required this.ImageUrl});
}

// Di chuyển homeGenres ra ngoài class để có thể truy cập từ bên ngoài
final List<Genres> homeGenres = [
  Genres(
    id: '1',
    genreName: 'Bối cảnh',
    ImageUrl: 'assets/images/classisctyle.jpg',
  ),
  Genres(
    id: '2',
    genreName: 'Hoa',
    ImageUrl: 'assets/images/startbackground.jpg',
  ),
  Genres(
    id: '3',
    genreName: 'Cổ điển',
    ImageUrl: 'assets/images/classisctyle.jpg',
  ),
  Genres(
    id: '4',
    genreName: 'Hiện đại',
    ImageUrl: 'assets/images/classisctyle.jpg',
  ),
  Genres(
    id: '5',
    genreName: 'Phong cảnh',
    ImageUrl: 'assets/images/classisctyle.jpg',
  ),
];
