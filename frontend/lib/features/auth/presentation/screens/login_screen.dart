<<<<<<< Updated upstream
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_state.dart';
=======
import "package:easy_localization/easy_localization.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
>>>>>>> Stashed changes
import '../providers/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
<<<<<<< Updated upstream
      ref.read(authProvider.notifier).login(
=======
      ref.read(authNotifierProvider.notifier).login(
>>>>>>> Stashed changes
            _usernameController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to state changes to show SnackBar on Error
<<<<<<< Updated upstream
    ref.listen(authProvider, (previous, next) {
=======
    ref.listen(authNotifierProvider, (previous, next) {
>>>>>>> Stashed changes
      next.maybeWhen(
        error: (message) {
          final isOffline = message.contains('çevrimdışı');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
<<<<<<< Updated upstream
              backgroundColor: isOffline
                  ? Colors.blueGrey
=======
              backgroundColor: isOffline
                  ? Colors.blueGrey
>>>>>>> Stashed changes
                  : Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        orElse: () {},
      );
    });

<<<<<<< Updated upstream
    final authState = ref.watch(authProvider);
=======
    final authState = ref.watch(authNotifierProvider);
>>>>>>> Stashed changes
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
<<<<<<< Updated upstream
                // App Logo
                Center(
                  child: Image.asset(
                    'assets/images/odak_logo.png',
                    height: 120,
                  ),
=======
                // Logo Placeholder for ODAK
                const Icon(
                  Icons.filter_center_focus,
                  size: 80,
                  color: Colors.blueAccent,
>>>>>>> Stashed changes
                ),
                const SizedBox(height: 16),
                Text(
                  'ODAK',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
<<<<<<< Updated upstream
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Hoş Geldiniz',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
=======
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        color: Colors.blueAccent,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'welcome_back'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey,
>>>>>>> Stashed changes
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
<<<<<<< Updated upstream
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
=======
                  decoration: InputDecoration(
                    labelText: 'username'.tr(),
                    prefixIcon: const Icon(Icons.person_outline),
                    border: const OutlineInputBorder(),
>>>>>>> Stashed changes
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
<<<<<<< Updated upstream
                    labelText: 'Password',
=======
                    labelText: 'password'.tr(),
>>>>>>> Stashed changes
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
<<<<<<< Updated upstream
                      : const Text('Login', style: TextStyle(fontSize: 16)),
=======
                      : Text('login'.tr(), style: const TextStyle(fontSize: 16)),
>>>>>>> Stashed changes
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: isLoading
                      ? null
<<<<<<< Updated upstream
                      : () => context.go('/register'),
                  child: const Text('Don\'t have an account? Register'),
=======
                      : () => context.push('/forgot-password'),
                  child: Text('forgot_password'.tr()),
                ),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () => context.go('/register'),
                  child: Text('dont_have_account'.tr()),
>>>>>>> Stashed changes
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
