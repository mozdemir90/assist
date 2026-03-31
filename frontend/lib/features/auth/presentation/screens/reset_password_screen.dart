import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/auth_notifier.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
<<<<<<< HEAD

=======

>>>>>>> feature/push-notifications-auth
      try {
        await ref
            .read(authProvider.notifier)
            .resetPassword(widget.token, _passwordController.text);
<<<<<<< HEAD

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('password_reset_success'.tr()),
=======

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('password_reset_success'.tr(defaultValue: 'Your password has been successfully reset. Please login.')),
>>>>>>> feature/push-notifications-auth
            backgroundColor: Colors.green,
          ),
        );
        context.go('/login');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('reset_password'.tr()),
=======
        title: Text('reset_password'.tr(defaultValue: 'Reset Password')),
>>>>>>> feature/push-notifications-auth
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
<<<<<<< HEAD
                  'enter_new_password'.tr(),
=======
                  'enter_new_password'.tr(defaultValue: 'Please enter your new password below.'),
>>>>>>> feature/push-notifications-auth
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
<<<<<<< HEAD
                    labelText: 'new_password'.tr(),
=======
                    labelText: 'new_password'.tr(defaultValue: 'New Password'),
>>>>>>> feature/push-notifications-auth
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
                      return 'password_required'.tr();
                    }
                    if (value.length < 8 ||
                        !value.contains(RegExp(r'[A-Z]')) ||
                        !value.contains(RegExp(r'[0-9]'))) {
                      return 'password_validation_error'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'confirm_password'.tr(),
                    prefixIcon: const Icon(Icons.lock_reset),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'confirm_password_required'.tr();
                    }
                    if (value != _passwordController.text) {
                      return 'passwords_do_not_match'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
<<<<<<< HEAD
                      : Text('reset_password'.tr()),
=======
                      : Text('reset_password'.tr(defaultValue: 'Reset Password')),
>>>>>>> feature/push-notifications-auth
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
