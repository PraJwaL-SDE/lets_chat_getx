import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/models/user_model.dart';

class ShareListItem extends StatelessWidget {
  final UserModel targetUser;
  final bool isSelected;

  ShareListItem({
    Key? key,
    required this.targetUser,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(targetUser.profilePic),
        radius: 25,
      ),
      title: Text(
        targetUser.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(targetUser.email),
      trailing: isSelected
          ? Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 18,
        ),
      )
          : const SizedBox.shrink(),
    );
  }
}
