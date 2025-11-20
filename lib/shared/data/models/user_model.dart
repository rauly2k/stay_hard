import 'package:cloud_firestore/cloud_firestore.dart';

/// User Profile Model for Firestore
/// Collection: users/{userId}
class UserModel {
  final String uid;
  final String? displayName;
  final String? email;
  final String? photoURL;
  final DateTime? createdAt;
  final String? commitmentMessage;
  final UserPreferences preferences;
  final String? selectedProgramId;
  final Map<String, dynamic>? questionnaireResponses;
  final DateTime? onboardingCompletedAt;

  const UserModel({
    required this.uid,
    this.displayName,
    this.email,
    this.photoURL,
    this.createdAt,
    this.commitmentMessage,
    this.preferences = const UserPreferences(),
    this.selectedProgramId,
    this.questionnaireResponses,
    this.onboardingCompletedAt,
  });

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoURL,
    DateTime? createdAt,
    String? commitmentMessage,
    UserPreferences? preferences,
    String? selectedProgramId,
    Map<String, dynamic>? questionnaireResponses,
    DateTime? onboardingCompletedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      commitmentMessage: commitmentMessage ?? this.commitmentMessage,
      preferences: preferences ?? this.preferences,
      selectedProgramId: selectedProgramId ?? this.selectedProgramId,
      questionnaireResponses:
          questionnaireResponses ?? this.questionnaireResponses,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoURL': photoURL,
        'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
        'commitmentMessage': commitmentMessage,
        'preferences': preferences.toJson(),
        'selectedProgramId': selectedProgramId,
        'questionnaireResponses': questionnaireResponses,
        'onboardingCompletedAt': onboardingCompletedAt != null
            ? Timestamp.fromDate(onboardingCompletedAt!)
            : null,
      };

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      photoURL: json['photoURL'] as String?,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      commitmentMessage: json['commitmentMessage'] as String?,
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(
              Map<String, dynamic>.from(json['preferences'] as Map))
          : const UserPreferences(),
      selectedProgramId: json['selectedProgramId'] as String?,
      questionnaireResponses: json['questionnaireResponses'] != null
          ? Map<String, dynamic>.from(
              json['questionnaireResponses'] as Map)
          : null,
      onboardingCompletedAt:
          (json['onboardingCompletedAt'] as Timestamp?)?.toDate(),
    );
  }

  factory UserModel.fromFirebaseAuth(
    String uid,
    String? displayName,
    String? email,
  ) {
    return UserModel(
      uid: uid,
      displayName: displayName,
      email: email,
      createdAt: DateTime.now(),
    );
  }
}

/// User Preferences nested in UserModel
class UserPreferences {
  final String theme; // 'light', 'dark', 'system'
  final String language; // 'en', 'es', etc.
  final String defaultView; // 'home', 'habits', 'analytics'
  final String dateFormat; // 'MM/DD/YYYY', 'DD/MM/YYYY'
  final bool habitReminders;
  final bool systemNotifications;
  final bool achievementNotifications;
  final bool streakAlerts;
  final bool goalDeadlineNotifications;
  final bool weeklyEmail;
  final bool marketingEmails;

  const UserPreferences({
    this.theme = 'system',
    this.language = 'en',
    this.defaultView = 'home',
    this.dateFormat = 'MM/DD/YYYY',
    this.habitReminders = true,
    this.systemNotifications = true,
    this.achievementNotifications = true,
    this.streakAlerts = true,
    this.goalDeadlineNotifications = true,
    this.weeklyEmail = false,
    this.marketingEmails = false,
  });

  UserPreferences copyWith({
    String? theme,
    String? language,
    String? defaultView,
    String? dateFormat,
    bool? habitReminders,
    bool? systemNotifications,
    bool? achievementNotifications,
    bool? streakAlerts,
    bool? goalDeadlineNotifications,
    bool? weeklyEmail,
    bool? marketingEmails,
  }) {
    return UserPreferences(
      theme: theme ?? this.theme,
      language: language ?? this.language,
      defaultView: defaultView ?? this.defaultView,
      dateFormat: dateFormat ?? this.dateFormat,
      habitReminders: habitReminders ?? this.habitReminders,
      systemNotifications: systemNotifications ?? this.systemNotifications,
      achievementNotifications:
          achievementNotifications ?? this.achievementNotifications,
      streakAlerts: streakAlerts ?? this.streakAlerts,
      goalDeadlineNotifications:
          goalDeadlineNotifications ?? this.goalDeadlineNotifications,
      weeklyEmail: weeklyEmail ?? this.weeklyEmail,
      marketingEmails: marketingEmails ?? this.marketingEmails,
    );
  }

  Map<String, dynamic> toJson() => {
        'theme': theme,
        'language': language,
        'defaultView': defaultView,
        'dateFormat': dateFormat,
        'habitReminders': habitReminders,
        'systemNotifications': systemNotifications,
        'achievementNotifications': achievementNotifications,
        'streakAlerts': streakAlerts,
        'goalDeadlineNotifications': goalDeadlineNotifications,
        'weeklyEmail': weeklyEmail,
        'marketingEmails': marketingEmails,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      defaultView: json['defaultView'] as String? ?? 'home',
      dateFormat: json['dateFormat'] as String? ?? 'MM/DD/YYYY',
      habitReminders: json['habitReminders'] as bool? ?? true,
      systemNotifications: json['systemNotifications'] as bool? ?? true,
      achievementNotifications:
          json['achievementNotifications'] as bool? ?? true,
      streakAlerts: json['streakAlerts'] as bool? ?? true,
      goalDeadlineNotifications:
          json['goalDeadlineNotifications'] as bool? ?? true,
      weeklyEmail: json['weeklyEmail'] as bool? ?? false,
      marketingEmails: json['marketingEmails'] as bool? ?? false,
    );
  }
}
