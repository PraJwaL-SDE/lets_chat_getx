import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel userModel;
   ProfileScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CircleAvatar(
            foregroundImage: NetworkImage(userModel.profilePic),
          ),
          
        ],
      ),
    );
  }
}
