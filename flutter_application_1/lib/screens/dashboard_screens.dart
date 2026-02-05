import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Budget'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTransactionScreen(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            _SummaryCard(title: 'Balance', amount: 0),
            SizedBox(height: 10),
            _SummaryCard(title: 'Income', amount: 0),
            SizedBox(height: 10),
            _SummaryCard(title: 'Expenses', amount: 0),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;

  const _SummaryCard({
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}