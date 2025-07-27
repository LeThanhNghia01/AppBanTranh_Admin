// lib/models/artist.dart
class Artist {
  final String id;
  final String artistname;
  final String? profilePictureUrl;
  final DateTime? createdAt;

  Artist({
    required this.id,
    required this.artistname,
    this.profilePictureUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Artist copyWith({
    String? id,
    String? artistname,
    String? profilePictureUrl,
    DateTime? createdAt,
    bool? isVerified,
  }) {
    return Artist(
      id: id ?? this.id,
      artistname: artistname ?? this.artistname,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artistname': artistname,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'],
      artistname: json['artistname'],
      profilePictureUrl: json['profilePictureUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Artist{id: $id, artistname: $artistname}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Artist && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
