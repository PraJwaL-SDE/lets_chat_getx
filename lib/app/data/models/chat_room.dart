import 'package:hive/hive.dart';
import 'package:lest_chat_5/app/data/models/message_model.dart';

part 'chat_room.g.dart';

@HiveType(typeId: 22)
class ChatRoom {
  @HiveField(0)
  String? id;

  @HiveField(1)
  Map<String, bool> participants;

  @HiveField(2)
  MessageModel? lastMessage;

  @HiveField(3)
  String? type;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String? keyboardStatus; // Added field

  @HiveField(6)
  String? messageStatus; // Added field

  ChatRoom({
    this.id,
    required this.participants,
    this.lastMessage,
    this.type,
    this.keyboardStatus, // Added field
    this.messageStatus, // Added field
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  @override
  String toString() {
    return 'ChatRoom{id: $id, participants: $participants, lastMessage: $lastMessage, type: $type, createdAt: $createdAt, keyboardStatus: $keyboardStatus, messageStatus: $messageStatus}';
  }

  ChatRoom.FromMap(Map<String, dynamic> map)
      : id = map["id"],
        participants = Map<String, bool>.from(map["participants"] ?? {}),
        lastMessage = map['lastMessage'] != null
            ? MessageModel.fromMap(map["lastMessage"])
            : null,
        type = map["type"],
        keyboardStatus = map["keyboardStatus"], // Added field
        messageStatus = map["messageStatus"], // Added field
        createdAt = DateTime.tryParse(map["createdAt"] ?? '') ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "participants": participants,
      "lastMessage": lastMessage?.toMap(),
      "type": type,
      "keyboardStatus": keyboardStatus, // Added field
      "messageStatus": messageStatus, // Added field
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
