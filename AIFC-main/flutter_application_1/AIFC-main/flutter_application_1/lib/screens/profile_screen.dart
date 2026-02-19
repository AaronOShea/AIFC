import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _currency = 'EUR';
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    final email = user?.email ?? 'Unknown user';
    final createdAt = user?.metadata.creationTime;
    final memberSince = _formatMemberSince(createdAt);
    final initials = _initialsFromEmail(email);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileHeaderCard(
                email: email,
                memberSince: memberSince,
                initials: initials,
              ),
              const SizedBox(height: 20),
              const _StatsRow(
                totalBudgets: 12,
                activeGoals: 3,
                savingsRate: 78,
              ),
              const SizedBox(height: 24),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.currency_exchange_rounded),
                        title: const Text('Currency'),
                        subtitle: Text(
                          _currencyLabel(_currency),
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        trailing: DropdownButton<String>(
                          value: _currency,
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(
                              value: 'USD',
                              child: Text('USD'),
                            ),
                            DropdownMenuItem(
                              value: 'EUR',
                              child: Text('EUR'),
                            ),
                            DropdownMenuItem(
                              value: 'GBP',
                              child: Text('GBP'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _currency = value;
                            });
                          },
                        ),
                      ),
                      const Divider(height: 0),
                      SwitchListTile(
                        secondary: const Icon(Icons.dark_mode_rounded),
                        title: const Text('Dark Mode'),
                        value: _darkMode,
                        onChanged: (value) {
                          setState(() {
                            _darkMode = value;
                          });
                        },
                      ),
                      const Divider(height: 0),
                      SwitchListTile(
                        secondary: const Icon(Icons.notifications_rounded),
                        title: const Text('Notifications'),
                        value: _notifications,
                        onChanged: (value) {
                          setState(() {
                            _notifications = value;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await AuthService.instance.signOut();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB71C1C),
                            side: const BorderSide(color: Color(0xFFB71C1C)),
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.logout_rounded),
                          label: const Text('Logout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMemberSince(DateTime? createdAt) {
    if (createdAt == null) return 'Member since Feb 2026';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final monthName = months[createdAt.month - 1];
    return 'Member since $monthName ${createdAt.year}';
  }

  String _initialsFromEmail(String email) {
    final prefix = email.split('@').first;
    if (prefix.isEmpty) return '?';
    final parts = prefix.split('.');
    if (parts.length >= 2) {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      final combined = '$first$second'.trim();
      return combined.isEmpty ? prefix[0].toUpperCase() : combined.toUpperCase();
    }
    return prefix[0].toUpperCase();
  }

  String _currencyLabel(String code) {
    switch (code) {
      case 'USD':
        return '\$ USD';
      case 'EUR':
        return '€ EUR';
      case 'GBP':
        return '£ GBP';
      default:
        return code;
    }
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final String email;
  final String memberSince;
  final String initials;

  const _ProfileHeaderCard({
    required this.email,
    required this.memberSince,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.green.shade100,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    memberSince,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalBudgets;
  final int activeGoals;
  final int savingsRate;

  const _StatsRow({
    required this.totalBudgets,
    required this.activeGoals,
    required this.savingsRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Budgets',
            value: '$totalBudgets',
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Goals Active',
            value: '$activeGoals',
            color: const Color(0xFFAF52DE),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Savings Rate',
            value: '$savingsRate%',
            color: const Color(0xFF1B5E20),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
