// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_notification_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AINotificationConfigAdapter extends TypeAdapter<AINotificationConfig> {
  @override
  final int typeId = 10;

  @override
  AINotificationConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AINotificationConfig(
      userId: fields[0] as String,
      archetype: fields[1] as AIArchetype,
      intensity: fields[2] as AIIntensity,
      isEnabled: fields[3] as bool,
      onboardingCompletedAt: fields[4] as DateTime,
      preferredNotificationHours: (fields[5] as List).cast<int>(),
      quietHours: (fields[6] as List).cast<int>(),
      lastModified: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AINotificationConfig obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.archetype)
      ..writeByte(2)
      ..write(obj.intensity)
      ..writeByte(3)
      ..write(obj.isEnabled)
      ..writeByte(4)
      ..write(obj.onboardingCompletedAt)
      ..writeByte(5)
      ..write(obj.preferredNotificationHours)
      ..writeByte(6)
      ..write(obj.quietHours)
      ..writeByte(7)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AINotificationConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AINotificationRecordAdapter extends TypeAdapter<AINotificationRecord> {
  @override
  final int typeId = 13;

  @override
  AINotificationRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AINotificationRecord(
      id: fields[0] as String,
      userId: fields[1] as String,
      message: fields[2] as String,
      archetype: fields[3] as AIArchetype,
      scenario: fields[4] as NotificationScenario,
      scheduledTime: fields[5] as DateTime,
      sentAt: fields[6] as DateTime?,
      viewedAt: fields[7] as DateTime?,
      dismissedAt: fields[8] as DateTime?,
      actionTaken: fields[9] as NotificationAction?,
      contextSnapshot: (fields[10] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, AINotificationRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.message)
      ..writeByte(3)
      ..write(obj.archetype)
      ..writeByte(4)
      ..write(obj.scenario)
      ..writeByte(5)
      ..write(obj.scheduledTime)
      ..writeByte(6)
      ..write(obj.sentAt)
      ..writeByte(7)
      ..write(obj.viewedAt)
      ..writeByte(8)
      ..write(obj.dismissedAt)
      ..writeByte(9)
      ..write(obj.actionTaken)
      ..writeByte(10)
      ..write(obj.contextSnapshot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AINotificationRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AIArchetypeAdapter extends TypeAdapter<AIArchetype> {
  @override
  final int typeId = 11;

  @override
  AIArchetype read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AIArchetype.drillSergeant;
      case 1:
        return AIArchetype.wiseMentor;
      case 2:
        return AIArchetype.friendlyCoach;
      case 3:
        return AIArchetype.motivationalSpeaker;
      case 4:
        return AIArchetype.philosopher;
      case 5:
        return AIArchetype.humorousFriend;
      case 6:
        return AIArchetype.competitor;
      case 7:
        return AIArchetype.growthGuide;
      default:
        return AIArchetype.drillSergeant;
    }
  }

  @override
  void write(BinaryWriter writer, AIArchetype obj) {
    switch (obj) {
      case AIArchetype.drillSergeant:
        writer.writeByte(0);
        break;
      case AIArchetype.wiseMentor:
        writer.writeByte(1);
        break;
      case AIArchetype.friendlyCoach:
        writer.writeByte(2);
        break;
      case AIArchetype.motivationalSpeaker:
        writer.writeByte(3);
        break;
      case AIArchetype.philosopher:
        writer.writeByte(4);
        break;
      case AIArchetype.humorousFriend:
        writer.writeByte(5);
        break;
      case AIArchetype.competitor:
        writer.writeByte(6);
        break;
      case AIArchetype.growthGuide:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIArchetypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AIIntensityAdapter extends TypeAdapter<AIIntensity> {
  @override
  final int typeId = 12;

  @override
  AIIntensity read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AIIntensity.low;
      case 1:
        return AIIntensity.medium;
      case 2:
        return AIIntensity.high;
      default:
        return AIIntensity.low;
    }
  }

  @override
  void write(BinaryWriter writer, AIIntensity obj) {
    switch (obj) {
      case AIIntensity.low:
        writer.writeByte(0);
        break;
      case AIIntensity.medium:
        writer.writeByte(1);
        break;
      case AIIntensity.high:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIIntensityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationScenarioAdapter extends TypeAdapter<NotificationScenario> {
  @override
  final int typeId = 14;

  @override
  NotificationScenario read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationScenario.morningMotivation;
      case 1:
        return NotificationScenario.middayCheckIn;
      case 2:
        return NotificationScenario.eveningReflection;
      case 3:
        return NotificationScenario.streakMilestone;
      case 4:
        return NotificationScenario.streakRecovery;
      case 5:
        return NotificationScenario.goalDeadlineApproaching;
      case 6:
        return NotificationScenario.habitRecommendation;
      case 7:
        return NotificationScenario.encouragement;
      case 8:
        return NotificationScenario.urgentAccountability;
      case 9:
        return NotificationScenario.celebration;
      case 10:
        return NotificationScenario.customTiming;
      default:
        return NotificationScenario.morningMotivation;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationScenario obj) {
    switch (obj) {
      case NotificationScenario.morningMotivation:
        writer.writeByte(0);
        break;
      case NotificationScenario.middayCheckIn:
        writer.writeByte(1);
        break;
      case NotificationScenario.eveningReflection:
        writer.writeByte(2);
        break;
      case NotificationScenario.streakMilestone:
        writer.writeByte(3);
        break;
      case NotificationScenario.streakRecovery:
        writer.writeByte(4);
        break;
      case NotificationScenario.goalDeadlineApproaching:
        writer.writeByte(5);
        break;
      case NotificationScenario.habitRecommendation:
        writer.writeByte(6);
        break;
      case NotificationScenario.encouragement:
        writer.writeByte(7);
        break;
      case NotificationScenario.urgentAccountability:
        writer.writeByte(8);
        break;
      case NotificationScenario.celebration:
        writer.writeByte(9);
        break;
      case NotificationScenario.customTiming:
        writer.writeByte(10);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationScenarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationActionAdapter extends TypeAdapter<NotificationAction> {
  @override
  final int typeId = 15;

  @override
  NotificationAction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return NotificationAction.dismissed;
      case 1:
        return NotificationAction.viewedHabits;
      case 2:
        return NotificationAction.completedHabit;
      case 3:
        return NotificationAction.openedApp;
      case 4:
        return NotificationAction.changedSettings;
      case 5:
        return NotificationAction.ignored;
      default:
        return NotificationAction.dismissed;
    }
  }

  @override
  void write(BinaryWriter writer, NotificationAction obj) {
    switch (obj) {
      case NotificationAction.dismissed:
        writer.writeByte(0);
        break;
      case NotificationAction.viewedHabits:
        writer.writeByte(1);
        break;
      case NotificationAction.completedHabit:
        writer.writeByte(2);
        break;
      case NotificationAction.openedApp:
        writer.writeByte(3);
        break;
      case NotificationAction.changedSettings:
        writer.writeByte(4);
        break;
      case NotificationAction.ignored:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
