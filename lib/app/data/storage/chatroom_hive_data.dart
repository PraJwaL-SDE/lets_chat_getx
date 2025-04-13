import 'package:hive_flutter/hive_flutter.dart';
import 'package:lest_chat_5/app/data/models/chat_room.dart';
import 'package:lest_chat_5/app/data/models/message_model.dart';

class ChatroomHiveData {
  static late Box<ChatRoom> _chatroomBox;

  static Future<void> initialize() async {
    try {
      Hive.registerAdapter(ChatRoomAdapter());
      if (!Hive.isAdapterRegistered(22)) {}
      _chatroomBox = await Hive.openBox<ChatRoom>('chatroomBox3');
    } catch (e) {
      throw Exception('Failed to initialize ChatroomHiveData.');
    }
  }

  static Future<void> setChatroom(ChatRoom chatroom) async {
    try {
      if (chatroom.lastMessage == null) {
        chatroom.lastMessage = MessageModel(
          id: '1',
          text: "tap here to start chat",
          createdOn: DateTime.now(),
        );
      }
      await _chatroomBox.put(chatroom.id, chatroom);
    } catch (e) {
      throw Exception('Failed to save chatroom.');
    }
  }

  static Future<ChatRoom?> getChatroom(String id) async {
    try {
      return _chatroomBox.get(id);
    } catch (e) {
      throw Exception('Failed to retrieve chatroom.');
    }
  }

  static Future<bool> doesChatroomExist(String id) async {
    try {
      return _chatroomBox.containsKey(id);
    } catch (e) {
      throw Exception('Failed to check chatroom existence.');
    }
  }

  static Stream<List<ChatRoom>> getAllChatroom() {
    try {
      return _chatroomBox.watch().map((event) {
        return _chatroomBox.values.toList();
      });
    } catch (e) {
      throw Exception('Failed to get chatroom stream.');
    }
  }

  static Future<List<ChatRoom>> getAllChatroomNow() async {
    try {
      return _chatroomBox.values.toList();
    } catch (e) {
      throw Exception('Failed to retrieve all chatrooms.');
    }
  }

  static Future<void> updateLastMessage(String chatroomId, MessageModel message) async {
    try {
      ChatRoom? chatRoom = _chatroomBox.get(chatroomId);
      if (chatRoom != null) {
        chatRoom.lastMessage = message;
        await _chatroomBox.put(chatroomId, chatRoom);
      }
    } catch (e) {
      throw Exception('Failed to update last message.');
    }
  }

  static Future<List<ChatRoom>> getChatroomBySender(String senderId) async {
    try {
      final allChatrooms = await getAllChatroomNow();
      return allChatrooms.where((chatroom) {
        return chatroom.participants.containsKey(senderId);
      }).toList();
    } catch (e) {
      throw Exception('Failed to find chatroom by sender.');
    }
  }

}
