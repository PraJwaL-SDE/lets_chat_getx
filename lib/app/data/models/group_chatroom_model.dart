import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:lest_chat_5/app/data/models/message_model.dart';

part 'group_chatroom_model.g.dart';

@HiveType(typeId: 5)
class GroupChatroomModel {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Map<String, bool> participants;

  @HiveField(3)
  String profilePic;

  @HiveField(4)
  DateTime createdOn;

  @HiveField(5)
  String? description;

  @HiveField(6)
  String creator;

  @HiveField(7)
  List<String> admin;

  @HiveField(8)
  MessageModel? lastMessage;

  GroupChatroomModel({
    required this.id,
    required this.name,
    required this.participants,
    required this.profilePic,
    required this.createdOn,
    this.description,
    required this.creator,
    required this.admin,
    this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'participants': participants,
      'profilePic': profilePic,
      'createdOn': createdOn.millisecondsSinceEpoch,
      'description': description,
      'creator': creator,
      'admin': admin,
      'lastMessage': lastMessage?.toMap(),
    };
  }

  factory GroupChatroomModel.fromMap(Map<String, dynamic> map) {
    return GroupChatroomModel(
      id: map['id'] as String,
      name: map['name'] as String,
      participants: (map['participants'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, value as bool),
      ),
      profilePic: map['profilePic'] as String,
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn'] as int),
      description: map['description'] as String?,
      creator: map['creator'] as String,
      admin: List<String>.from(map['admin']),
      lastMessage: map['lastMessage'] != null
          ? MessageModel.fromMap(map['lastMessage'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupChatroomModel.fromJson(String source) =>
      GroupChatroomModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupChatroomModel(id: $id, name: $name, participants: $participants, profilePic: $profilePic, createdOn: $createdOn, description: $description, creator: $creator, admin: $admin, lastMessage: $lastMessage)';
  }
}
