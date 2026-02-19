import 'package:flutter/material.dart';

import '../services/goal_service.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final GoalService _service = GoalService.instance;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _service.init();
    if (!mounted) return;
    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: const Text('💰 Goals'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF10B981),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF10B981)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateGoalSheet,
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: _initialized
              ? ValueListenableBuilder<List<Goal>>(
                  valueListenable: _service.goalsNotifier,
                  builder: (context, goals, _) {
                    if (goals.isEmpty) {
                      return _EmptyState();
                    }
                    return ListView.builder(
                      itemCount: goals.length,
                      itemBuilder: (context, index) {
                        final goal = goals[index];
                        return _GoalCard(goal: goal);
                      },
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                  ),
                ),
        ),
      ),
    );
  }

  void _showCreateGoalSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final nameController = TextEditingController();
        final targetController = TextEditingController();
        final monthlyController = TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Goal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Name',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  decoration: const InputDecoration(
                    labelText: 'Target Amount (€)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: monthlyController,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Contribution (€)',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final target =
                          double.tryParse(targetController.text.trim()) ?? 0;
                      final monthly =
                          double.tryParse(monthlyController.text.trim()) ?? 0;

                      if (name.isEmpty || target <= 0 || monthly <= 0) {
                        return;
                      }

                      await _service.addGoal(
                        name: name,
                        targetAmount: target,
                        monthlyContribution: monthly,
                      );
                      if (!mounted) return;
                      Navigator.of(ctx).pop();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Create Goal'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_circle,
            size: 100,
            color: Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          const Text(
            'No goals yet 😢',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to start saving!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = goal.progress;
    final percent = (progress * 100).round();
    final reached = progress >= 1.0;

    final targetText = '€${goal.targetAmount.toStringAsFixed(0)} target';
    final amountText =
        '€${goal.currentAmount.toStringAsFixed(0)} / €${goal.targetAmount.toStringAsFixed(0)} ($percent%)${reached ? ' ✓' : ''}';

    final monthlyLine = _monthlyLine(goal);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            goal.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                targetText,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF10B981),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amountText,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                ),
              ),
              if (monthlyLine != null) ...[
                const SizedBox(height: 4),
                Text(
                  monthlyLine,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _monthlyLine(Goal goal) {
    if (goal.monthlyContribution <= 0) return null;
    final estimated = goal.estimatedCompletion;
    if (estimated == null) {
      return '€${goal.monthlyContribution.toStringAsFixed(0)}/mo';
    }
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
    final monthName = months[estimated.month - 1];
    return '€${goal.monthlyContribution.toStringAsFixed(0)}/mo → $monthName ${estimated.year}';
  }
}

