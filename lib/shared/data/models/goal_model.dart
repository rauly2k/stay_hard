import 'package:cloud_firestore/cloud_firestore.dart';

/// Goal model for tracking user goals linked to habits
class Goal {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String category;
  final DateTime targetDate;
  final String status; // 'active', 'completed', 'paused'
  final List<String> habitIds; // Linked habit IDs
  final DateTime createdAt;
  final DateTime? completedAt;

  const Goal({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.category,
    required this.targetDate,
    required this.status,
    required this.habitIds,
    required this.createdAt,
    this.completedAt,
  });

  Goal copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? category,
    DateTime? targetDate,
    String? status,
    List<String>? habitIds,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      habitIds: habitIds ?? this.habitIds,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'description': description,
        'category': category,
        'targetDate': Timestamp.fromDate(targetDate),
        'status': status,
        'habitIds': habitIds,
        'createdAt': Timestamp.fromDate(createdAt),
        'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      };

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      targetDate: (json['targetDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: json['status'] as String? ?? 'active',
      habitIds: (json['habitIds'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
    );
  }
}
