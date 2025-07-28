// lib/models/admin.dart

class Admins {
  final String id;
  final String adminname;
  final String password;
  final String email;
  final String phone;
  final String? profilePictureUrl;
  final DateTime? createdAt;

  Admins({
    required this.id,
    required this.adminname,
    required this.password,
    required this.email,
    required this.phone,
    this.profilePictureUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Admins copyWith({
    String? id,
    String? adminname,
    String? password,
    String? email,
    String? phone,
    String? profilePictureUrl,
    DateTime? createdAt,
  }) {
    return Admins(
      id: id ?? this.id,
      adminname: adminname ?? this.adminname,
      password: password ?? this.password,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adminname': adminname,
      'password': password,
      'email': email,
      'phone': phone,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from JSON
  factory Admins.fromJson(Map<String, dynamic> json) {
    return Admins(
      id: json['id'],
      adminname: json['adminname'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      profilePictureUrl: json['profilePictureUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  @override
  String toString() {
    return 'Admins{id: $id, adminname: $adminname}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Admins && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
