// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      login: fields[0] as String,
      avatarUrl: fields[1] as String,
      htmlUrl: fields[2] as String,
      publicRepos: fields[3] as int,
      updatedAt: fields[4] as DateTime,
      name: fields[5] as String?,
      bio: fields[6] as String?,
      company: fields[7] as String?,
      location: fields[8] as String?,
      followers: fields[9] as int?,
      following: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.avatarUrl)
      ..writeByte(2)
      ..write(obj.htmlUrl)
      ..writeByte(3)
      ..write(obj.publicRepos)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.bio)
      ..writeByte(7)
      ..write(obj.company)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.followers)
      ..writeByte(10)
      ..write(obj.following);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
