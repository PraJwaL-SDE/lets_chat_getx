import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lest_chat_5/app/data/models/user_model.dart';

class AuthProvider {
  String? userId;
  String? userEmail;

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://chatting-backend-j5p5.onrender.com/getUserByEmail?email=$email",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        userId = user['_id'];
        userEmail = user['email'];

        return UserModel(
          id: userId!,
          email: userEmail!,
          name: user['fullName'] ?? '',
          deviceToken: user['deviceToken'] ?? '',
          profilePic: user['avatar'] ?? 'https://cdn-icons-png.flaticon.com/128/17701/17701286.png',
          createdAt: DateTime.parse(user['createdAt']),
        );
      } else {
        print(
            "Failed to get user by email. Status: ${response.statusCode}, Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error in getUserByEmail: $e");
      return null;
    }
  }

  Future<UserModel?> getUserById(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://chatting-backend-j5p5.onrender.com/getUserById?id=$id",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];

        // Required fields
        final userId = user['_id'];
        final userEmail = user['email'];

        // Return UserModel with null-aware operators
        return UserModel(
          id: userId,
          email: userEmail,
          name: user['fullName'] ?? '',
          deviceToken: user['deviceToken'] ?? '',
          profilePic: user['avatar'] ?? 'https://cdn-icons-png.flaticon.com/128/17701/17701286.png',
          createdAt: DateTime.parse(user['createdAt']),
        );
      } else {
        print(
            "Failed to get user by ID. Status: ${response.statusCode}, Body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error in getUserById: $e");
      return null;
    }
  }


  Future<UserModel?> updateUserDetail(
      String email,
      String googleId,
      String avatar,
      String fullName,
      String deviceToken,
      ) async {
    if (email.isEmpty || fullName.isEmpty || googleId.isEmpty) {
      print("Email, Full Name, and Google ID are required.");
      return null;
    }

    String url = "https://chatting-backend-j5p5.onrender.com/googleLogin";

    final body = {
      "email": email,
      "googleId": googleId,
      "avatar": avatar,
      "fullName": fullName,
      "deviceToken": deviceToken,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];

        return UserModel(
          id: user['_id'],
          name: user['fullName'],
          email: user['email'],
          deviceToken: user['deviceToken'],
          createdAt: DateTime.parse(user['createdAt']),
          profilePic: user['avatar'],
        );

      } else {
        print(
          "Failed to login. Status: ${response.statusCode}, Body: ${response.body}",
        );
        return null;
      }
    } catch (e) {
      print("Error during googleLogin: $e");
      return null;
    }
  }
}
