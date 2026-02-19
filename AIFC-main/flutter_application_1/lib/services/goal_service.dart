import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final double monthlyContribution;
  final DateTime createdAt;

  const Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.monthlyContribution,
    required this.createdAt,
  });

  double get progress {
    if (targetAmount <= 0) return 0;
    final value = currentAmount / targetAmount;
    if (value.isNaN || value.isInfinite) return 0;
    return value.clamp(0.0, 1.0);
  }

  DateTime? get estimatedCompletion {
    if (monthlyContribution <= 0 || targetAmount <= 0) return null;
    final remaining = targetAmount - currentAmount;
    if (remaining <= 0) return createdAt;
    final monthsNeeded = (remaining / monthlyContribution).ceil();
    if (monthsNeeded <= 0) return createdAt;
    return DateTime(createdAt.year, createdAt.month + monthsNeeded);
  }

  Goal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    double? monthlyContribution,
    DateTime? createdAt,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'monthlyContribution': monthlyContribution,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      monthlyContribution: (json['monthlyContribution'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class GoalService {
  GoalService._();

  static final GoalService instance = GoalService._();

  static const String _storageKey = 'goals';

  final ValueNotifier<List<Goal>> goalsNotifier =
      ValueNotifier<List<Goal>>(<Goal>[]);

  bool _initialized = false;

  List<Goal> get goals => goalsNotifier.value;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      final now = DateTime.now();
      final sampleGoals = <Goal>[
        Goal(
          id: 'emergency-fund',
          name: 'Emergency Fund',
          targetAmount: 5000,
          currentAmount: 1750,
          monthlyContribution: 156,
          createdAt: DateTime(now.year, now.month, 1),
        ),
        Goal(
          id: 'new-laptop',
          name: 'New Laptop',
          targetAmount: 1200,
          currentAmount: 984, // 82%
          monthlyContribution: 120,
          createdAt: DateTime(now.year, now.month - 4, 1),
        ),
        Goal(
          id: 'vacation',
          name: 'Vacation',
          targetAmount: 3000,
          currentAmount: 360, // 12%
          monthlyContribution: 150,
          createdAt: DateTime(now.year, now.month, 1),
        ),
      ];
      goalsNotifier.value = sampleGoals;
      await _save();
      return;
    }

    try {
      final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
      final loaded = list
          .map((e) => Goal.fromJson(e as Map<String, dynamic>))
          .toList();
      goalsNotifier.value = loaded;
    } catch (_) {
      goalsNotifier.value = <Goal>[];
    }
  }

  Future<void> addGoal({
    required String name,
    required double targetAmount,
    required double monthlyContribution,
  }) async {
    final now = DateTime.now();
    final goal = Goal(
      id: now.microsecondsSinceEpoch.toString(),
      name: name,
      targetAmount: targetAmount,
      currentAmount: 0,
      monthlyContribution: monthlyContribution,
      createdAt: now,
    );
    final updated = List<Goal>.from(goalsNotifier.value)..add(goal);
    goalsNotifier.value = updated;
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final list = goalsNotifier.value.map((g) => g.toJson()).toList();
    await prefs.setString(_storageKey, json.encode(list));
  }
}

