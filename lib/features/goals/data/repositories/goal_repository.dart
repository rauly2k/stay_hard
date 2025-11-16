import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/goal_model.dart';

/// Repository for managing user goals
class GoalRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  GoalRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Get all goals for the current user
  Stream<List<Goal>> getGoals() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('goals')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return Goal.fromJson(doc.data());
            } catch (e) {
              // ignore: avoid_print
              print('Error parsing goal: $e');
              return null;
            }
          })
          .whereType<Goal>()
          .toList();
    });
  }

  /// Get active goals only
  Stream<List<Goal>> getActiveGoals() {
    return getGoals().map((goals) {
      return goals.where((goal) => goal.status == 'active').toList();
    });
  }

  /// Get a single goal by ID
  Future<Goal?> getGoalById(String goalId) async {
    try {
      final doc = await _firestore.collection('goals').doc(goalId).get();
      if (!doc.exists) return null;
      return Goal.fromJson(doc.data()!);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching goal: $e');
      return null;
    }
  }

  /// Create a new goal
  Future<void> createGoal(Goal goal) async {
    try {
      await _firestore.collection('goals').doc(goal.id).set(goal.toJson());
    } catch (e) {
      // ignore: avoid_print
      print('Error creating goal: $e');
      rethrow;
    }
  }

  /// Update an existing goal
  Future<void> updateGoal(Goal goal) async {
    try {
      await _firestore
          .collection('goals')
          .doc(goal.id)
          .update(goal.toJson());
    } catch (e) {
      // ignore: avoid_print
      print('Error updating goal: $e');
      rethrow;
    }
  }

  /// Delete a goal
  Future<void> deleteGoal(String goalId) async {
    try {
      await _firestore.collection('goals').doc(goalId).delete();
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting goal: $e');
      rethrow;
    }
  }

  /// Mark goal as completed
  Future<void> completeGoal(String goalId) async {
    try {
      await _firestore.collection('goals').doc(goalId).update({
        'status': 'completed',
        'completedAt': Timestamp.now(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error completing goal: $e');
      rethrow;
    }
  }

  /// Update goal status
  Future<void> updateGoalStatus(String goalId, String status) async {
    try {
      final update = <String, dynamic>{'status': status};

      if (status == 'completed') {
        update['completedAt'] = Timestamp.now();
      }

      await _firestore.collection('goals').doc(goalId).update(update);
    } catch (e) {
      // ignore: avoid_print
      print('Error updating goal status: $e');
      rethrow;
    }
  }

  /// Link a habit to a goal
  Future<void> linkHabitToGoal(String goalId, String habitId) async {
    try {
      final goal = await getGoalById(goalId);
      if (goal == null) return;

      if (!goal.habitIds.contains(habitId)) {
        final updatedHabitIds = [...goal.habitIds, habitId];
        await _firestore.collection('goals').doc(goalId).update({
          'habitIds': updatedHabitIds,
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error linking habit to goal: $e');
      rethrow;
    }
  }

  /// Unlink a habit from a goal
  Future<void> unlinkHabitFromGoal(String goalId, String habitId) async {
    try {
      final goal = await getGoalById(goalId);
      if (goal == null) return;

      final updatedHabitIds = goal.habitIds.where((id) => id != habitId).toList();
      await _firestore.collection('goals').doc(goalId).update({
        'habitIds': updatedHabitIds,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error unlinking habit from goal: $e');
      rethrow;
    }
  }
}
