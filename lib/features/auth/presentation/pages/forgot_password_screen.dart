import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccessSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleSendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authNotifierProvider.notifier)
          .sendPasswordResetEmail(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    // Listen to auth state for error and success messages
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.errorMessage != null) {
        _showErrorSnackBar(next.errorMessage!);
        ref.read(authNotifierProvider.notifier).clearMessages();
      }
      if (next.successMessage != null) {
        setState(() {
          _emailSent = true;
        });
        _showSuccessSnackBar(next.successMessage!);
        ref.read(authNotifierProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: 40,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Forgot Password?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _emailSent
                      ? 'Check your email for a password reset link'
                      : "Enter your email and we'll send you a link to reset your password",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 40),

                if (!_emailSent) ...[
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _handleSendResetEmail(),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Send reset link button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          authState.isLoading ? null : _handleSendResetEmail,
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Send Reset Link'),
                    ),
                  ),
                ] else ...[
                  // Success state
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Email sent to ${_emailController.text}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Back to login button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to Log In'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Resend email button
                  TextButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            setState(() {
                              _emailSent = false;
                            });
                          },
                    child: const Text('Resend Email'),
                  ),
                ],

                const SizedBox(height: 24),

                // Back to login link (when email not sent)
                if (!_emailSent)
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('Back to Log In'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
