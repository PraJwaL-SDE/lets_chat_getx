// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_chatroom_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupChatroomModelAdapter extends TypeAdapter<GroupChatroomModel> {
  @override
  final int typeId = 5;

  @override
  GroupChatroomModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupChatroomModel(
      id: fields[0] as String,
      name: fields[1] as String,
      participants: (fields[2] as Map).cast<String, bool>(),
      profilePic: fields[3] as String,
      createdOn: fields[4] as DateTime,
      description: fields[5] as String?,
      creator: fields[6] as String,
      admin: (fields[7] as List).cast<String>(),
      lastMessage: fields[8] as MessageModel?,
    );
  }

  @override
  void write(BinaryWriter writer, GroupChatroomModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.participants)
      ..writeByte(3)
      ..write(obj.profilePic)
      ..writeByte(4)
      ..write(obj.createdOn)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.creator)
      ..writeByte(7)
      ..write(obj.admin)
      ..writeByte(8)
      ..write(obj.lastMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupChatroomModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
