import 'package:flutter/material.dart';

import '../../../../data/models/user_model.dart';

class AddUserItem extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback onTap;
  const AddUserItem({super.key, required this.userModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.network(
          userModel.profilePic ?? "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
        ),
        title: Text(userModel.name),
        subtitle: Text(userModel.email),
        trailing: GestureDetector(onTap: onTap,child: Icon(Icons.cancel,color: Colors.redAccent,))
    );
  }
}
