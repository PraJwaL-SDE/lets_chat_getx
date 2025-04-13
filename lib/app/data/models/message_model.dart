import 'package:hive/hive.dart';

part 'message_model.g.dart';

enum ReceiverStatus { sent, delivered, seen }

@HiveType(typeId: 3)
class MessageModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? sender;
  @HiveField(2)
  String? text;
  @HiveField(3)
  bool? seen;
  @HiveField(4)
  DateTime? createdOn;
  @HiveField(5)
  String? type;
  @HiveField(6)
  String? receiver; // Changed to String
  @HiveField(7)
  String? chatroomId;
  @HiveField(8)
  String? fileUrl; // New field
  @HiveField(9)
  String? filePath; // New field

  // Constructor
  MessageModel({
    this.id,
    this.sender,
    this.text,
    this.seen,
    this.createdOn,
    this.type,
    this.receiver, // Updated field
    this.chatroomId,
    this.fileUrl, // Include new field
    this.filePath, // Include new field
  });

  // Named constructor to create an instance from a map
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['message_id'],
      sender: map['sender'],
      text: map['text'],
      seen: map['seen'],
      createdOn: map['createdOn'] != null ? DateTime.parse(map['createdOn']) : null,
      type: map['type'],
      receiver: map['receiver'], // Parse as String
      chatroomId: map['chatroomId'],
      fileUrl: map['fileUrl'], // Parse new field
      filePath: map['filePath'], // Parse new field
    );
  }

  // Method to convert an instance to a map
  Map<String, dynamic> toMap() {
    return {
      'message_id': id,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createdOn': createdOn?.toIso8601String(),
      'type': type,
      'receiver': receiver, // Convert as String
      'chatroomId': chatroomId,
      'fileUrl': fileUrl, // Include new field
      'filePath': filePath, // Include new field
    };
  }
}
