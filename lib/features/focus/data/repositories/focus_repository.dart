import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/data/models/focus_session_model.dart';

/// Repository for managing focus sessions
class FocusRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FocusRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  /// Get sessions collection reference
  CollectionReference<Map<String, dynamic>> get _sessionsCollection =>
      _firestore.collection('focusSessions');

  /// Create a new focus session
  Future<void> createSession(FocusSession session) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _sessionsCollection.doc(session.id).set(session.toJson());
  }

  /// Update an existing focus session
  Future<void> updateSession(FocusSession session) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _sessionsCollection.doc(session.id).update(session.toJson());
  }

  /// Delete a focus session
  Future<void> deleteSession(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    await _sessionsCollection.doc(sessionId).delete();
  }

  /// Get a single focus session by ID
  Future<FocusSession?> getSession(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final doc = await _sessionsCollection.doc(sessionId).get();
    if (!doc.exists) return null;

    return FocusSession.fromJson(doc.data()!);
  }

  /// Stream of all focus sessions for the current user
  Stream<List<FocusSession>> watchSessions() {
    if (_userId == null) return Stream.value([]);

    return _sessionsCollection
        .where('userId', isEqualTo: _userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FocusSession.fromJson(doc.data()))
            .toList());
  }

  /// Get active focus session if any
  Stream<FocusSession?> watchActiveSession() {
    if (_userId == null) return Stream.value(null);

    return _sessionsCollection
        .where('userId', isEqualTo: _userId)
        .where('status', isEqualTo: FocusSessionStatus.active.name)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return FocusSession.fromJson(snapshot.docs.first.data());
    });
  }

  /// Get focus sessions by status
  Future<List<FocusSession>> getSessionsByStatus(
      FocusSessionStatus status) async {
    if (_userId == null) throw Exception('User not authenticated');

    final snapshot = await _sessionsCollection
        .where('userId', isEqualTo: _userId)
        .where('status', isEqualTo: status.name)
        .get();

    return snapshot.docs
        .map((doc) => FocusSession.fromJson(doc.data()))
        .toList();
  }

  /// Get focus sessions within a date range
  Future<List<FocusSession>> getSessionsInRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    if (_userId == null) throw Exception('User not authenticated');

    final snapshot = await _sessionsCollection
        .where('userId', isEqualTo: _userId)
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return snapshot.docs
        .map((doc) => FocusSession.fromJson(doc.data()))
        .toList();
  }

  /// Start a focus session
  Future<void> startSession(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final session = await getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    // Check if there's already an active session
    final activeSessions =
        await getSessionsByStatus(FocusSessionStatus.active);
    if (activeSessions.isNotEmpty) {
      throw Exception('Another session is already active');
    }

    final updatedSession = session.copyWith(
      status: FocusSessionStatus.active,
      startTime: DateTime.now(),
    );

    await updateSession(updatedSession);
  }

  /// Pause a focus session
  Future<void> pauseSession(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final session = await getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    final updatedSession = session.copyWith(
      status: FocusSessionStatus.paused,
    );

    await updateSession(updatedSession);
  }

  /// Resume a paused focus session
  Future<void> resumeSession(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final session = await getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    final updatedSession = session.copyWith(
      status: FocusSessionStatus.active,
    );

    await updateSession(updatedSession);
  }

  /// Complete a focus session
  Future<void> completeSession(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final session = await getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    final updatedSession = session.copyWith(
      status: FocusSessionStatus.completed,
      endTime: DateTime.now(),
    );

    await updateSession(updatedSession);
  }

  /// Cancel a focus session
  Future<void> cancelSession(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final session = await getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    final updatedSession = session.copyWith(
      status: FocusSessionStatus.cancelled,
      endTime: DateTime.now(),
    );

    await updateSession(updatedSession);
  }

  /// Increment block attempts for a session
  Future<void> incrementBlockAttempts(String sessionId) async {
    if (_userId == null) throw Exception('User not authenticated');

    final session = await getSession(sessionId);
    if (session == null) throw Exception('Session not found');

    final updatedSession = session.copyWith(
      blockAttempts: session.blockAttempts + 1,
    );

    await updateSession(updatedSession);
  }

  /// Calculate focus statistics
  Future<FocusStatistics> getStatistics() async {
    if (_userId == null) throw Exception('User not authenticated');

    final allSessions = await _sessionsCollection
        .where('userId', isEqualTo: _userId)
        .get()
        .then((snapshot) =>
            snapshot.docs.map((doc) => FocusSession.fromJson(doc.data())).toList());

    if (allSessions.isEmpty) {
      return FocusStatistics.empty();
    }

    final completedSessions = allSessions
        .where((s) => s.status == FocusSessionStatus.completed)
        .toList();

    final totalFocusTime = completedSessions.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + session.duration,
    );

    final averageDuration = completedSessions.isEmpty
        ? Duration.zero
        : Duration(
            milliseconds:
                totalFocusTime.inMilliseconds ~/ completedSessions.length,
          );

    // Calculate streaks
    final sortedSessions = completedSessions
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? lastDate;

    for (final session in sortedSessions) {
      final sessionDate = DateTime(
        session.createdAt.year,
        session.createdAt.month,
        session.createdAt.day,
      );

      if (lastDate == null) {
        tempStreak = 1;
        lastDate = sessionDate;
      } else {
        final daysDiff = lastDate.difference(sessionDate).inDays;
        if (daysDiff == 1) {
          tempStreak++;
        } else if (daysDiff > 1) {
          if (currentStreak == 0) {
            currentStreak = tempStreak;
          }
          longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;
          tempStreak = 1;
        }
        lastDate = sessionDate;
      }
    }

    if (currentStreak == 0) currentStreak = tempStreak;
    longestStreak = tempStreak > longestStreak ? tempStreak : longestStreak;

    // Most blocked apps
    final blockCounts = <String, int>{};
    for (final session in allSessions) {
      for (final app in session.blockedApps) {
        blockCounts[app] = (blockCounts[app] ?? 0) + session.blockAttempts;
      }
    }

    return FocusStatistics(
      totalSessions: allSessions.length,
      completedSessions: completedSessions.length,
      totalFocusTime: totalFocusTime,
      averageSessionDuration: averageDuration,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      mostBlockedApps: blockCounts,
      lastSessionDate:
          sortedSessions.isNotEmpty ? sortedSessions.first.createdAt : null,
    );
  }
}
