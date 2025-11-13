import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pain_scale_app/data/repositories/auth_repository.dart';
import 'package:pain_scale_app/presentation/providers/user_provider.dart';
import 'package:pain_scale_app/presentation/screens/tablet/register_tablet_screen.dart';
import 'package:pain_scale_app/presentation/screens/screens.dart';

class LoginTabletScreen extends StatefulWidget {
  const LoginTabletScreen({super.key});

  @override
  State<LoginTabletScreen> createState() => _LoginTabletScreenState();
}

class _LoginTabletScreenState extends State<LoginTabletScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final authRepository = Provider.of<AuthRepository>(context, listen: false);
      final user = await authRepository.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUid(user.uid);
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OptionsTabletScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sign in. Please check your credentials.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterTabletScreen(),
                    ),
                  );
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
