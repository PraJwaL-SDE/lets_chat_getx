import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/data/provider/auth/auth_provider.dart';
import 'package:lest_chat_5/app/data/storage/user_hive_data.dart';

import '../../../../data/models/chat_room.dart';
import '../../../../data/models/user_model.dart';
import '../../../../utils/constants/constant_colors.dart';
import '../../../chatting/view/chatting_screen.dart';


class HomeScreenTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final UserModel userModel;
  HomeScreenTile({super.key, required this.chatRoom, required this.userModel});

  // final authService = AuthService();

  Stream<UserModel?> _streamOtherUser() async* {
    try {
      final otherUserId = chatRoom.participants?.keys.firstWhere(
            (id) => id != userModel.id,
        orElse: () => '',
      );

      if (otherUserId == null || otherUserId.isEmpty) {
        yield null;
        return;
      }

      // Yield the local user first
      final localUser = UserHiveData.getUserModel(otherUserId);
      if (localUser != null) {
        yield localUser;
      }

      // Then get the server user
      final serverUser = await AuthProvider().getUserById(otherUserId);

      if (serverUser != null) {
        // You could also update Hive here if needed
        yield serverUser;
      }
    } catch (e) {
      print('Error fetching user: $e');
      yield null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: _streamOtherUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ListTile(
            title: Text('Loading...'),
            subtitle: Text('Please wait'),
          );
        }

        final otherUser = snapshot.data!;
        final lastMessage = chatRoom.lastMessage;

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChattingScreen(
                  userModel: userModel,
                  targetModel: otherUser,
                  chatRoom: chatRoom,
                ),
              ),
            );
          },
          leading: Hero(
            tag: "t_${chatRoom.id}",
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                otherUser.profilePic ??
                    "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
              ),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(otherUser.name ?? 'Unknown User'),
              if (lastMessage?.createdOn != null)
                Text(
                  '${lastMessage!.createdOn!.hour}:${lastMessage.createdOn!.minute.toString().padLeft(2, '0')} '
                      '${lastMessage.createdOn!.day}/${lastMessage.createdOn!.month}',
                ),
            ],
          ),
          subtitle: lastMessage != null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  lastMessage.text ?? '',
                  style: const TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (lastMessage.seen != null && !lastMessage.seen!)
                Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: ConstantColors.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                  ),
                  child: const Center(
                    child: Text(
                      "1",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          )
              : null,
        );
      },
    );

  }
}
