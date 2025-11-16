import 'package:flutter/material.dart';

/// Habit category for organization
enum HabitCategory {
  foundation,
  physical,
  mental,
  discipline,
  lifestyle,
}

/// Type of habit configuration needed
enum HabitConfigType {
  none, // No configuration needed (e.g., "Make your bed")
  duration, // Duration in minutes (e.g., "Exercise for 30 minutes")
  quantity, // Quantity with unit (e.g., "Drink 8 glasses of water")
  time, // Specific time (e.g., "Wake up at 6:00 AM")
}

/// Habit template for program creation
@immutable
class HabitTemplate {
  final String id;
  final String name;
  final String detail;
  final IconData icon;
  final Color color;
  final HabitCategory category;
  final HabitConfigType configType;
  final String? defaultUnit; // For quantity type (e.g., "glasses", "pages")
  final int? defaultValue; // Default quantity or duration

  const HabitTemplate({
    required this.id,
    required this.name,
    required this.detail,
    required this.icon,
    required this.color,
    required this.category,
    required this.configType,
    this.defaultUnit,
    this.defaultValue,
  });

  /// Check if this habit requires configuration
  bool get requiresConfiguration => configType != HabitConfigType.none;
}
