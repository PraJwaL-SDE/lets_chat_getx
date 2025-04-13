import 'package:get/get.dart';
import 'package:lest_chat_5/app/data/models/chat_room.dart';

import '../../../data/models/user_model.dart';
import '../../../data/provider/auth/auth_provider.dart';
import '../../../data/storage/user_hive_data.dart';

class ShareUserListController extends GetxController{
  Stream<UserModel?> streamOtherUser(ChatRoom chatRoom,UserModel userModel) async* {
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

  var selectedChatrooms = <ChatRoom>[].obs;
  var isLoading = false.obs;



}