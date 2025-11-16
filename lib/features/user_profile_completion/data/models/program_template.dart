import 'package:flutter/material.dart';

/// Program archetype for personalized onboarding
@immutable
class ProgramTemplate {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> coreHabitIds;

  const ProgramTemplate({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.icon,
    required this.color,
    required this.coreHabitIds,
  });
}
