import 'package:hive_flutter/hive_flutter.dart';
import 'package:lest_chat_5/app/data/models/group_chatroom_model.dart';
import 'package:lest_chat_5/app/data/models/message_model.dart';

class GroupChatroomHiveData {
  static late Box<GroupChatroomModel> _groupChatroomBox;

  static Future<void> initialize() async {
    try {
      if (!Hive.isAdapterRegistered(5)) {
        Hive.registerAdapter(GroupChatroomModelAdapter());
      }

      _groupChatroomBox = await Hive.openBox<GroupChatroomModel>('groupChatroomBox');
    } catch (e) {
      throw Exception('Failed to initialize GroupChatroomHiveData.');
    }
  }

  static Future<void> setGroupChatroom(GroupChatroomModel groupChatroom) async {
    try {
      if (groupChatroom.lastMessage == null) {
        groupChatroom.lastMessage = MessageModel(
          id: '1',
          text: "tap here to start group chat",
          createdOn: DateTime.now(),
        );
      }
      await _groupChatroomBox.put(groupChatroom.id, groupChatroom);
    } catch (e) {
      throw Exception('Failed to save group chatroom.');
    }
  }

  static Future<GroupChatroomModel?> getGroupChatroom(String id) async {
    try {
      return _groupChatroomBox.get(id);
    } catch (e) {
      throw Exception('Failed to retrieve group chatroom.');
    }
  }

  static Future<bool> doesGroupChatroomExist(String id) async {
    try {
      return _groupChatroomBox.containsKey(id);
    } catch (e) {
      throw Exception('Failed to check group chatroom existence.');
    }
  }

  static Stream<List<GroupChatroomModel>> getAllGroupChatrooms() {
    try {
      return _groupChatroomBox.watch().map((event) {
        return _groupChatroomBox.values.toList();
      });
    } catch (e) {
      throw Exception('Failed to get group chatroom stream.');
    }
  }

  static Future<List<GroupChatroomModel>> getAllGroupChatroomsNow() async {
    try {
      return _groupChatroomBox.values.toList();
    } catch (e) {
      throw Exception('Failed to retrieve all group chatrooms.');
    }
  }

  static Future<void> updateLastMessage(String chatroomId, MessageModel message) async {
    try {
      GroupChatroomModel? chatRoom = _groupChatroomBox.get(chatroomId);
      if (chatRoom != null) {
        chatRoom.lastMessage = message;
        await _groupChatroomBox.put(chatroomId, chatRoom);
      }
    } catch (e) {
      throw Exception('Failed to update last message.');
    }
  }

  static Future<List<GroupChatroomModel>> getGroupChatroomsByMember(String memberId) async {
    try {
      final allGroupChatrooms = await getAllGroupChatroomsNow();
      return allGroupChatrooms.where((chatroom) {
        return chatroom.participants.containsKey(memberId);
      }).toList();
    } catch (e) {
      throw Exception('Failed to find group chatrooms by member.');
    }
  }
}
