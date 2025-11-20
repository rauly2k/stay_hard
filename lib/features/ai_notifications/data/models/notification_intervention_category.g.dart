// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_intervention_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryPreferencesAdapter extends TypeAdapter<CategoryPreferences> {
  @override
  final int typeId = 17;

  @override
  CategoryPreferences read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryPreferences(
      category: fields[0] as InterventionCategory,
      enabled: fields[1] as bool,
      customSettings: (fields[2] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CategoryPreferences obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.enabled)
      ..writeByte(2)
      ..write(obj.customSettings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryPreferencesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InterventionCategoryAdapter extends TypeAdapter<InterventionCategory> {
  @override
  final int typeId = 16;

  @override
  InterventionCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InterventionCategory.morningMotivation;
      case 1:
        return InterventionCategory.missedHabitRecovery;
      case 2:
        return InterventionCategory.lowMoraleBoost;
      case 3:
        return InterventionCategory.streakCelebration;
      case 4:
        return InterventionCategory.eveningCheckIn;
      case 5:
        return InterventionCategory.comebackSupport;
      case 6:
        return InterventionCategory.progressInsights;
      default:
        return InterventionCategory.morningMotivation;
    }
  }

  @override
  void write(BinaryWriter writer, InterventionCategory obj) {
    switch (obj) {
      case InterventionCategory.morningMotivation:
        writer.writeByte(0);
        break;
      case InterventionCategory.missedHabitRecovery:
        writer.writeByte(1);
        break;
      case InterventionCategory.lowMoraleBoost:
        writer.writeByte(2);
        break;
      case InterventionCategory.streakCelebration:
        writer.writeByte(3);
        break;
      case InterventionCategory.eveningCheckIn:
        writer.writeByte(4);
        break;
      case InterventionCategory.comebackSupport:
        writer.writeByte(5);
        break;
      case InterventionCategory.progressInsights:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterventionCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
