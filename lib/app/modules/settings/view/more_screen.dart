import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _listTile(
              iconPath: "assets/icons/language_icon.png",
              title: "Language",
              trailing: DropdownButton<String>(
                items: [
                  DropdownMenuItem(value: "English", child: Text("English")),
                  DropdownMenuItem(value: "Spanish", child: Text("Spanish")),
                ],
                onChanged: (value) {},
              ),
            ),
            _listTile(
              iconPath: "assets/icons/dark_mode_icon.png",
              title: "Dark Mode",
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            _listTile(
              iconPath: "assets/icons/mute_light.png",
              title: "Mute Notification",
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
            _listTile(
              iconPath: "assets/icons/noti_light.png",
              title: "Custom Notification",
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            _listTile(
              iconPath: "assets/icons/invite_icon_light.png",
              title: "Invite Friend",
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            _listTile(
              iconPath: "assets/icons/bottom_group_inactive.png",
              title: "Joined Groups",
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            _listTile(
              iconPath: "assets/icons/hide_inactive_light.png",
              title: "Hide Chat History",
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(value: false, onChanged: (value) {}),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
            _listTile(
              iconPath: "assets/icons/terms_service_light.png",
              title: "Terms of Service",
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            _listTile(
              iconPath: "assets/icons/about_app_light.png",
              title: "About App",
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            _listTile(
              iconPath: "assets/icons/help_center_light.png",
              title: "Help Centre",
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            _listTile(
              iconPath: "assets/icons/logout_light_red.png",
              title: "Logout",
              trailing: SizedBox.shrink(),

              titleColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTile({
    required String iconPath,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
    Color? tileColor,
    Color? titleColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      color: tileColor ?? Colors.white,
      child: ListTile(
        leading: Image.asset(
          iconPath,
          width: 32,
          height: 32,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: titleColor ?? Colors.black87,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
