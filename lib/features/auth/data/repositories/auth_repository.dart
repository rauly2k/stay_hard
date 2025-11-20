import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Abstract authentication repository interface
abstract class AuthRepository {
  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Sign in with Google
  Future<UserCredential> signInWithGoogle();

  /// Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<UserCredential> signUpWithEmail(String email, String password);

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Sign out
  Future<void> signOut();

  /// Get current user
  User? get currentUser;
}

/// Firebase authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  AuthRepositoryImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        // Use the web client ID from google-services.json for server auth
        serverClientId: '354041009676-jd28jhgjkvr1iteg9f32drcl27k6kmhc.apps.googleusercontent.com',
      );
      _isInitialized = true;
    }
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Ensure GoogleSignIn is initialized
      await _ensureInitialized();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate();

      if (googleUser == null) {
        throw Exception('Google sign in aborted by user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential using the id token
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }

  @override
  Future<UserCredential> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Ensure GoogleSignIn is initialized before signing out
      await _ensureInitialized();

      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.disconnect(),
      ]);
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  /// Handle Firebase Auth exceptions and return user-friendly error messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
