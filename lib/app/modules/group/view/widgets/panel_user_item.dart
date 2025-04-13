import 'package:flutter/material.dart';

import '../../../../data/models/user_model.dart';

class PanelUserItem extends StatelessWidget {
  final UserModel userModel;
  final bool isChecked; // Controlled by state management

  const PanelUserItem({
    super.key,
    required this.userModel,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        userModel.profilePic,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
      title: Text(userModel.name),
      subtitle: Text(userModel.email),
      trailing: Checkbox(
        value: isChecked,
        onChanged: null, // State management will handle changes
      ),
    );
  }
}
