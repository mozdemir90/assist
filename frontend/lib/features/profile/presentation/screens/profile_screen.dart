import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/theme_provider.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authProvider);

    String username = 'Kullanıcı';
    String email = 'mail@odak.app';

    // Safely attempt to extract user info from auth state if possible.
    authState.maybeWhen(
      authenticated: (user) {
        username = user.username;
        email = user.email;
      },
      orElse: () {},
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil & Ayarlar'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
              child: const Icon(Icons.person, size: 50, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 16),
            Text(
              username,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              email,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
            const SizedBox(height: 32),

            // Theme settings
            _buildSectionHeader(context, 'Tasarım Ayarları'),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.textSecondaryLight.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Sistem Teması'),
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeModeProvider.notifier).setTheme(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Açık Tema (Light Mode)'),
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeModeProvider.notifier).setTheme(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Koyu Tema (Dark Mode)'),
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    onChanged: (val) => ref.read(themeModeProvider.notifier).setTheme(val!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Hesap Yönetimi'),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.textSecondaryLight.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text('Şifre Değiştir'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Şifre değiştirme özelliği yakında!')),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              icon: const Icon(Icons.logout, color: AppColors.errorRed),
              label: const Text('Oturumu Kapat', style: TextStyle(color: AppColors.errorRed)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.errorRed),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondaryLight,
              ),
        ),
      ),
    );
  }
}
