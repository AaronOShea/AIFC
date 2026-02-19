import 'package:flutter/material.dart';
import '../app/transaction_provider.dart';
import '../data/transaction_store.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.userEmail,
    required this.onLogout,
  });

  final String? userEmail;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final store = TransactionProvider.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final hasBudget = store.hasBudgetSet;
          final budgetValue = store.monthlyBudget;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel('Monthly budget'),
                        const SizedBox(height: 12),
                        _MonthlyBudgetCard(
                          hasBudget: hasBudget,
                          budgetValue: budgetValue,
                          onSetBudget: () => _showSetBudgetDialog(context, store),
                        ),
                        const SizedBox(height: 24),
                        const _SectionLabel('Account'),
                        const SizedBox(height: 12),
                        _ProfileRow(
                          label: 'Email',
                          subtitle: userEmail ?? 'Not signed in',
                          icon: Icons.email_outlined,
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        _ProfileRow(
                          label: 'Log out',
                          subtitle: 'Sign out of your account',
                          icon: Icons.logout_rounded,
                          onTap: () async {
                            await onLogout();
                          },
                        ),
                        const SizedBox(height: 24),
                        const _SectionLabel('About'),
                        const SizedBox(height: 12),
                        _ProfileRow(
                          label: 'Finance Coach',
                          subtitle: 'Budget & goals tracker',
                          icon: Icons.info_outline_rounded,
                          onTap: () {},
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static void _showSetBudgetDialog(BuildContext context, TransactionStore store) {
    final controller = TextEditingController(
      text: store.monthlyBudget > 0
          ? store.monthlyBudget.toStringAsFixed(0)
          : '',
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monthly budget'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Your monthly budget',
            hintText: 'e.g. 1500',
            prefixText: '\$ ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final raw = controller.text.trim().replaceAll(',', '.');
              final amount = double.tryParse(raw);
              if (amount != null && amount >= 0) {
                store.setMonthlyBudget(amount);
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade800,
      ),
    );
  }
}

class _MonthlyBudgetCard extends StatelessWidget {
  final bool hasBudget;
  final double budgetValue;
  final VoidCallback onSetBudget;

  const _MonthlyBudgetCard({
    required this.hasBudget,
    required this.budgetValue,
    required this.onSetBudget,
  });

  static String _formatAmount(double v) {
    if (v <= 0) return '—';
    final abs = v.abs();
    if (abs >= 1000) {
      return '\$${abs.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          )}';
    }
    return '\$${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Color(0xFF2E7D32),
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasBudget ? _formatAmount(budgetValue) : 'Not set',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hasBudget
                          ? 'Your monthly spending limit'
                          : 'Set a limit to track spending',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onSetBudget,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                ),
                child: Text(hasBudget ? 'Edit' : 'Set budget'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileRow({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2E7D32),
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
