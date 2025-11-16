import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/alarm_model.dart';

/// Repository for managing user alarms
class AlarmRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AlarmRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// Get all alarms for the current user
  Stream<List<AlarmModel>> getAlarms() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('alarms')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            try {
              return AlarmModel.fromJson(doc.data());
            } catch (e) {
              // ignore: avoid_print
              print('Error parsing alarm: $e');
              return null;
            }
          })
          .whereType<AlarmModel>()
          .toList();
    });
  }

  /// Get enabled alarms only
  Stream<List<AlarmModel>> getEnabledAlarms() {
    return getAlarms().map((alarms) {
      return alarms.where((alarm) => alarm.isEnabled).toList();
    });
  }

  /// Get a single alarm by ID
  Future<AlarmModel?> getAlarmById(String alarmId) async {
    try {
      final doc = await _firestore.collection('alarms').doc(alarmId).get();
      if (!doc.exists) return null;
      return AlarmModel.fromJson(doc.data()!);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching alarm: $e');
      return null;
    }
  }

  /// Create a new alarm
  Future<void> createAlarm(AlarmModel alarm) async {
    try {
      await _firestore.collection('alarms').doc(alarm.id).set(alarm.toJson());
    } catch (e) {
      // ignore: avoid_print
      print('Error creating alarm: $e');
      rethrow;
    }
  }

  /// Update an existing alarm
  Future<void> updateAlarm(AlarmModel alarm) async {
    try {
      await _firestore
          .collection('alarms')
          .doc(alarm.id)
          .update(alarm.toJson());
    } catch (e) {
      // ignore: avoid_print
      print('Error updating alarm: $e');
      rethrow;
    }
  }

  /// Delete an alarm
  Future<void> deleteAlarm(String alarmId) async {
    try {
      await _firestore.collection('alarms').doc(alarmId).delete();
    } catch (e) {
      // ignore: avoid_print
      print('Error deleting alarm: $e');
      rethrow;
    }
  }

  /// Toggle alarm enabled status
  Future<void> toggleAlarm(String alarmId, bool isEnabled) async {
    try {
      await _firestore.collection('alarms').doc(alarmId).update({
        'isEnabled': isEnabled,
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error toggling alarm: $e');
      rethrow;
    }
  }
}
