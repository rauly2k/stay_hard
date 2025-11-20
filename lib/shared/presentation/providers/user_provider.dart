import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

/// Provider for current user's Firestore data
final userProfileProvider = StreamProvider<UserModel?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
    if (!doc.exists) {
      // Return basic user from Firebase Auth
      return UserModel.fromFirebaseAuth(
        user.uid,
        user.displayName,
        user.email,
      );
    }
    return UserModel.fromJson(doc.data()!, user.uid);
  });
});

/// Notifier for updating user profile
class UserProfileNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> updateProfile(UserModel user) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateDisplayName(String uid, String displayName) async {
    state = const AsyncValue.loading();
    try {
      // Update Firebase Auth
      await FirebaseAuth.instance.currentUser?.updateDisplayName(displayName);

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'displayName': displayName}, SetOptions(merge: true));

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updateCommitmentMessage(String uid, String message) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'commitmentMessage': message}, SetOptions(merge: true));
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updatePreferences(String uid, UserPreferences prefs) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'preferences': prefs.toJson()}, SetOptions(merge: true));
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> updatePhotoURL(String uid, String photoURL) async {
    state = const AsyncValue.loading();
    try {
      // Update Firebase Auth
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoURL);

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'photoURL': photoURL}, SetOptions(merge: true));

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> deleteAccount(String uid) async {
    state = const AsyncValue.loading();
    try {
      // Delete Firestore data
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Delete Firebase Auth user
      await FirebaseAuth.instance.currentUser?.delete();

      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

final userProfileNotifierProvider =
    NotifierProvider<UserProfileNotifier, AsyncValue<void>>(
  UserProfileNotifier.new,
);
