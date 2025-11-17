import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/focus_session_model.dart';

/// Repository for managing app time limits and usage tracking
class AppTimeLimitRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  /// Collection references
  CollectionReference get _limitsCollection =>
      _firestore.collection('appTimeLimits');
  CollectionReference get _usageCollection =>
      _firestore.collection('appUsageRecords');

  // ==================== App Time Limits ====================

  /// Create a new app time limit
  Future<void> createTimeLimit(AppTimeLimit limit) async {
    await _limitsCollection.doc(limit.id).set(limit.toJson());
  }

  /// Update an existing time limit
  Future<void> updateTimeLimit(AppTimeLimit limit) async {
    await _limitsCollection.doc(limit.id).update(limit.toJson());
  }

  /// Delete a time limit
  Future<void> deleteTimeLimit(String limitId) async {
    await _limitsCollection.doc(limitId).delete();
  }

  /// Get a specific time limit by ID
  Future<AppTimeLimit?> getTimeLimit(String limitId) async {
    final doc = await _limitsCollection.doc(limitId).get();
    if (!doc.exists) return null;
    return AppTimeLimit.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// Get time limit for a specific app package
  Future<AppTimeLimit?> getTimeLimitByPackage(String packageName) async {
    final querySnapshot = await _limitsCollection
        .where('userId', isEqualTo: _userId)
        .where('packageName', isEqualTo: packageName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;
    return AppTimeLimit.fromJson(
      querySnapshot.docs.first.data() as Map<String, dynamic>,
    );
  }

  /// Get all time limits for current user
  Future<List<AppTimeLimit>> getTimeLimits() async {
    final querySnapshot =
        await _limitsCollection.where('userId', isEqualTo: _userId).get();

    return querySnapshot.docs
        .map((doc) => AppTimeLimit.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Watch all time limits (stream)
  Stream<List<AppTimeLimit>> watchTimeLimits() {
    return _limitsCollection
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                AppTimeLimit.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Watch enabled time limits only
  Stream<List<AppTimeLimit>> watchEnabledTimeLimits() {
    return _limitsCollection
        .where('userId', isEqualTo: _userId)
        .where('isEnabled', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                AppTimeLimit.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // ==================== App Usage Records ====================

  /// Get or create today's usage record for an app
  Future<AppUsageRecord> getTodayUsageRecord(String packageName) async {
    final today = _normalizeDate(DateTime.now());
    final recordId = '${_userId}_${packageName}_${today.millisecondsSinceEpoch}';

    final doc = await _usageCollection.doc(recordId).get();
    if (doc.exists) {
      return AppUsageRecord.fromJson(doc.data() as Map<String, dynamic>);
    }

    // Create new record for today
    final newRecord = AppUsageRecord(
      id: recordId,
      userId: _userId,
      packageName: packageName,
      date: today,
      totalUsage: Duration.zero,
      lastUpdated: DateTime.now(),
    );

    await _usageCollection.doc(recordId).set(newRecord.toJson());
    return newRecord;
  }

  /// Update usage record with new usage time
  Future<void> updateUsageRecord(String recordId, Duration totalUsage) async {
    await _usageCollection.doc(recordId).update({
      'totalUsageSeconds': totalUsage.inSeconds,
      'lastUpdated': Timestamp.fromDate(DateTime.now()),
    });
  }

  /// Get usage records for a date range
  Future<List<AppUsageRecord>> getUsageRecords({
    String? packageName,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query query = _usageCollection.where('userId', isEqualTo: _userId);

    if (packageName != null) {
      query = query.where('packageName', isEqualTo: packageName);
    }

    if (startDate != null) {
      query = query.where('date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
    }

    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) =>
            AppUsageRecord.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get all usage records for today
  Future<Map<String, Duration>> getTodayAllAppUsage() async {
    final today = _normalizeDate(DateTime.now());
    final querySnapshot = await _usageCollection
        .where('userId', isEqualTo: _userId)
        .where('date', isEqualTo: Timestamp.fromDate(today))
        .get();

    final Map<String, Duration> usageMap = {};
    for (final doc in querySnapshot.docs) {
      final record =
          AppUsageRecord.fromJson(doc.data() as Map<String, dynamic>);
      usageMap[record.packageName] = record.totalUsage;
    }

    return usageMap;
  }

  /// Check if an app has exceeded its daily limit
  Future<bool> hasExceededLimit(String packageName) async {
    final limit = await getTimeLimitByPackage(packageName);
    if (limit == null || !limit.isEnabled) return false;

    final usageRecord = await getTodayUsageRecord(packageName);
    return usageRecord.totalUsage >= limit.dailyLimit;
  }

  /// Get remaining time for an app today
  Future<Duration> getRemainingTime(String packageName) async {
    final limit = await getTimeLimitByPackage(packageName);
    if (limit == null || !limit.isEnabled) return Duration.zero;

    final usageRecord = await getTodayUsageRecord(packageName);
    final remaining = limit.dailyLimit - usageRecord.totalUsage;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Get apps that have time limits configured
  Future<List<String>> getAppsWithLimits() async {
    final limits = await getTimeLimits();
    return limits.map((limit) => limit.packageName).toList();
  }

  /// Get list of apps that are currently blocked due to time limit
  Future<List<String>> getBlockedAppsByTimeLimit() async {
    final limits = await getTimeLimits();
    final blockedApps = <String>[];

    for (final limit in limits) {
      if (!limit.isEnabled) continue;

      final exceeded = await hasExceededLimit(limit.packageName);
      if (exceeded) {
        blockedApps.add(limit.packageName);
      }
    }

    return blockedApps;
  }

  /// Clean up old usage records (older than 30 days)
  Future<void> cleanupOldRecords() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final querySnapshot = await _usageCollection
        .where('userId', isEqualTo: _userId)
        .where('date', isLessThan: Timestamp.fromDate(thirtyDaysAgo))
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  // ==================== Helper Methods ====================

  /// Normalize date to start of day (00:00:00)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
