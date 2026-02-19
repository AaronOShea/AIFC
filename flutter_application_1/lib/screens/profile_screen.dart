import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_rounded, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Manage your account',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  await AuthService.instance.signOut();
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
