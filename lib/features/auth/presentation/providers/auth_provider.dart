import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

/// Provider for auth repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

/// Provider for authentication state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

/// Authentication state class
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

/// Authentication state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState());

  /// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.signInWithEmail(email, password);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Successfully signed in',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.signUpWithEmail(email, password);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Account created successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.signInWithGoogle();
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Successfully signed in with Google',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.sendPasswordResetEmail(email);
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset email sent. Please check your inbox.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _authRepository.signOut();
      state = state.copyWith(
        isLoading: false,
        successMessage: 'Successfully signed out',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Clear messages
  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }
}

/// Provider for auth notifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
