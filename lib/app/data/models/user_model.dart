import 'package:hive/hive.dart';

part 'user_model.g.dart';
@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String deviceToken;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final String profilePic; // New field for profile picture URL

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.deviceToken,
    required this.createdAt,
    required this.profilePic,
  });

  /// Converts the UserModel instance to a map for database storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'device_token': deviceToken,
      'created_at': createdAt.toIso8601String(),
      'profile_pic': profilePic,
    };
  }

  /// Factory method to create a UserModel from a map retrieved from the database.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      deviceToken: map['device_token'],
      createdAt: DateTime.parse(map['created_at']),
      profilePic: map['profile_pic'] ?? '', // Default to empty string if null
    );
  }

  @override
  String toString() {
    return 'UserModel{id: $id, name: $name, email: $email, deviceToken: $deviceToken, createdAt: $createdAt, profilePic: $profilePic}';
  }
}
