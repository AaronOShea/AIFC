import 'package:flutter/material.dart';
import '../app/auth_service.dart';

/// Login / Signup screen shown before any main content.
class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.authService,
    required this.onSuccess,
  });

  final AuthService authService;
  final VoidCallback onSuccess;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();
  final _signupConfirmController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_errorMessage != null) setState(() => _errorMessage = null);
  }

  bool _isValidEmail(String s) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(s);

  bool _isValidPassword(String s) =>
      s.length >= 8 && s.contains(RegExp(r'[A-Z]'));

  Future<void> _login() async {
    _clearError();
    final email = _loginEmailController.text.trim();
    final password = _loginPasswordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please enter email and password');
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }
    setState(() => _isLoading = true);
    final ok = await widget.authService.login(email, password);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (ok) {
      widget.onSuccess();
    } else {
      setState(() =>
          _errorMessage = 'Email or password incorrect. Sign up if you don\'t have an account.');
    }
  }

  Future<void> _signUp() async {
    _clearError();
    final email = _signupEmailController.text.trim();
    final password = _signupPasswordController.text;
    final confirm = _signupConfirmController.text;
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }
    if (!_isValidEmail(email)) {
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }
    if (!_isValidPassword(password)) {
      setState(() => _errorMessage =
          'Password must be at least 8 characters with one capital letter');
      return;
    }
    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }
    setState(() => _isLoading = true);
    await widget.authService.signUp(email, password);
    if (!mounted) return;
    setState(() => _isLoading = false);
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(
              'Finance Coach',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Budget, goals & AI tips',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
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
                children: [
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF2E7D32),
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorColor: const Color(0xFF2E7D32),
                    indicatorWeight: 3,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Sign up'),
                    ],
                  ),
                  SizedBox(
                    height: 340,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _LoginForm(
                          emailController: _loginEmailController,
                          passwordController: _loginPasswordController,
                          isLoading: _isLoading,
                          onLogin: _login,
                          onChanged: _clearError,
                        ),
                        _SignupForm(
                          emailController: _signupEmailController,
                          passwordController: _signupPasswordController,
                          confirmController: _signupConfirmController,
                          isLoading: _isLoading,
                          onSignUp: _signUp,
                          onChanged: _clearError,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB71C1C).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFB71C1C).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: Colors.red.shade700,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onChanged,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: isLoading ? null : onLogin,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Log in'),
          ),
        ],
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.isLoading,
    required this.onSignUp,
    required this.onChanged,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool isLoading;
  final VoidCallback onSignUp;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password (min 8 chars, 1 capital)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: confirmController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirm password',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_outline_rounded),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: isLoading ? null : onSignUp,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Create account'),
          ),
        ],
      ),
    );
  }
}
