import 'package:flutter/material.dart';
import '../app/transaction_provider.dart';
import '../data/transaction_store.dart';
import '../models/savings_goal_model.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = TransactionProvider.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        title: const Text('Goals'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGoalDialog(context, store),
        backgroundColor: const Color(0xFF2E7D32),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Goal'),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final goals = store.goals;
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
                        const _SectionLabel('Your savings goals'),
                        const SizedBox(height: 12),
                        if (goals.isEmpty)
                          _EmptyGoalsCard(
                            onAddGoal: () => _showAddGoalDialog(context, store),
                          )
                        else
                          ...goals.map(
                            (g) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _GoalCard(
                                goal: g,
                                onAddProgress: () =>
                                    _showAddProgressDialog(context, store, g),
                                onDelete: () => _confirmDeleteGoal(context, store, g),
                              ),
                            ),
                          ),
                        const SizedBox(height: 100),
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

  static void _showAddGoalDialog(BuildContext context, TransactionStore store) {
    final nameController = TextEditingController();
    final targetController = TextEditingController();
    DateTime? deadline;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New savings goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Goal name',
                    hintText: 'e.g. Holiday fund',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetController,
                  decoration: const InputDecoration(
                    labelText: 'Target amount',
                    prefixText: '\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    deadline == null
                        ? 'No deadline'
                        : 'By ${_formatDate(deadline!)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (picked != null) setState(() => deadline = picked);
                    },
                    child: Text(deadline == null ? 'Set deadline' : 'Change'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final target = double.tryParse(
                  targetController.text.trim().replaceAll(',', '.'),
                );
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a goal name')),
                  );
                  return;
                }
                if (target == null || target <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid target amount')),
                  );
                  return;
                }
                store.addGoal(SavingsGoal(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  targetAmount: target,
                  deadline: deadline,
                ));
                if (context.mounted) Navigator.pop(ctx);
              },
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  static void _showAddProgressDialog(
    BuildContext context,
    TransactionStore store,
    SavingsGoal goal,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add to "${goal.name}"'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Amount to add',
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
              final amount = double.tryParse(
                controller.text.trim().replaceAll(',', '.'),
              );
              if (amount != null && amount > 0) {
                store.addToGoal(goal.id, amount);
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2E7D32)),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  static void _confirmDeleteGoal(
    BuildContext context,
    TransactionStore store,
    SavingsGoal goal,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete goal?'),
        content: Text(
          'Remove "${goal.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              store.removeGoal(goal.id);
              if (context.mounted) Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFB71C1C)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
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

class _EmptyGoalsCard extends StatelessWidget {
  final VoidCallback onAddGoal;

  const _EmptyGoalsCard({required this.onAddGoal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.flag_rounded,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No goals yet',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Set a savings goal to track your progress and stay motivated.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAddGoal,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text('Add goal'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback onAddProgress;
  final VoidCallback onDelete;

  const _GoalCard({
    required this.goal,
    required this.onAddProgress,
    required this.onDelete,
  });

  static String _formatAmount(double v) {
    final abs = v.abs();
    if (abs >= 1000) {
      return abs.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    return abs.toStringAsFixed(0);
  }

  static String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = goal.progressPercent;
    final isReached = goal.isReached;

    return Container(
      padding: const EdgeInsets.all(16),
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
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isReached ? Icons.check_circle_rounded : Icons.flag_rounded,
                  color: const Color(0xFF2E7D32),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goal.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${_formatAmount(goal.currentAmount)} / \$${_formatAmount(goal.targetAmount)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert_rounded, color: Colors.grey.shade600),
                onSelected: (value) {
                  if (value == 'add') {
                    onAddProgress();
                  } else if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'add',
                    child: Row(
                      children: [
                        Icon(Icons.add_rounded, size: 20),
                        SizedBox(width: 8),
                        Text('Add progress'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFB71C1C)),
                        SizedBox(width: 8),
                        Text('Delete goal', style: TextStyle(color: Color(0xFFB71C1C))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (goal.deadline != null) ...[
            const SizedBox(height: 6),
            Text(
              'By ${_formatDate(goal.deadline!)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                isReached
                    ? const Color(0xFF2E7D32)
                    : progress >= 0.75
                        ? const Color(0xFFF9A825)
                        : const Color(0xFF5AC8FA),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              if (!isReached)
                TextButton(
                  onPressed: onAddProgress,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                  ),
                  child: const Text('Add progress'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
