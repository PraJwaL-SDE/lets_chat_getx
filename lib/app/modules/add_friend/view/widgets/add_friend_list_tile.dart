import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';
import '../../../../utils/constants/constant_colors.dart';

class AddFriendListTile extends StatelessWidget {
  final UserModel userModel;
  final VoidCallback onAddFriend;

  const AddFriendListTile({
    super.key,
    required this.userModel,
    required this.onAddFriend,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          userModel.profilePic ?? "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
        ),
      ),
      title: Text(userModel.name ?? 'Unknown'),
      subtitle: Text(userModel.email ?? 'No email provided'),
      trailing: IconButton(
        icon: Icon(Icons.person_add, color: ConstantColors.primary),
        onPressed: onAddFriend,
      ),
    );
  }
}
