// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationPreferencesAdapter extends TypeAdapter<NotificationPreferences> {
  @override
  final int typeId = 18;

  @override
  NotificationPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreferences(
      userId: fields[0] as String,
      aiNotificationsEnabled: fields[1] as bool,
      dailyNotificationLimit: fields[2] as int,
      quietHoursStart: fields[3] as String,
      quietHoursEnd: fields[4] as String,
      categoryPreferences: (fields[5] as Map).cast<String, CategoryPreferences>(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreferences obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.aiNotificationsEnabled)
      ..writeByte(2)
      ..write(obj.dailyNotificationLimit)
      ..writeByte(3)
      ..write(obj.quietHoursStart)
      ..writeByte(4)
      ..write(obj.quietHoursEnd)
      ..writeByte(5)
      ..write(obj.categoryPreferences)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
