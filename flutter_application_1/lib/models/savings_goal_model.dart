/// A savings goal with target amount and optional deadline.
class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  double currentAmount;
  final DateTime? deadline;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    this.deadline,
  });

  double get progressPercent {
    if (targetAmount <= 0) return 0;
    return (currentAmount / targetAmount).clamp(0.0, 1.0);
  }

  bool get isReached => currentAmount >= targetAmount;

  SavingsGoal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline ?? this.deadline,
    );
  }
}
