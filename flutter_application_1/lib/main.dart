import 'package:flutter/material.dart';
import 'data/transaction_store.dart';
import 'app/transaction_provider.dart';
import 'app/auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = await AuthService.create();
  runApp(BudgetApp(authService: authService));
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key, required this.authService});

  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    final store = TransactionStore();
    return TransactionProvider(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance Coach',
        theme: ThemeData(primarySwatch: Colors.green),
        home: _AuthWrapper(authService: authService),
      ),
    );
  }
}

class _AuthWrapper extends StatefulWidget {
  const _AuthWrapper({required this.authService});

  final AuthService authService;

  @override
  State<_AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<_AuthWrapper> {
  void _goToApp() => setState(() {});

  void _logout() => setState(() {});

  @override
  Widget build(BuildContext context) {
    if (widget.authService.isLoggedIn) {
      return MainShell(
        onLogout: () async {
          await widget.authService.logout();
          if (mounted) _logout();
        },
        userEmail: widget.authService.email,
      );
    }
    return AuthScreen(
      authService: widget.authService,
      onSuccess: _goToApp,
    );
  }
}
