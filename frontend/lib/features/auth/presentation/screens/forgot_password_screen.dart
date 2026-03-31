import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/auth_notifier.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

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
            .forgotPassword(_emailController.text.trim());
<<<<<<< HEAD

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('password_reset_sent'.tr()),
=======

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('password_reset_sent'.tr(defaultValue: 'If an account exists, a reset link has been sent.')),
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
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text('forgot_password'.tr()),
=======
        title: Text('forgot_password'.tr(defaultValue: 'Forgot Password')),
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
                  'forgot_password_desc'.tr(),
=======
                  'forgot_password_desc'.tr(defaultValue: 'Enter your email address and we will send you a link to reset your password.'),
>>>>>>> feature/push-notifications-auth
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'email'.tr(),
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'email_required'.tr();
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
<<<<<<< HEAD
                      return 'invalid_email'.tr();
=======
                      return 'invalid_email'.tr(defaultValue: 'Enter a valid email address');
>>>>>>> feature/push-notifications-auth
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
                      : Text('send_reset_link'.tr()),
=======
                      : Text('send_reset_link'.tr(defaultValue: 'Send Reset Link')),
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
