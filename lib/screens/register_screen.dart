import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';
import '../models/app_user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter your full name.');
      return;
    }

    if (email.isEmpty) {
      _showMessage('Please enter your email.');
      return;
    }

    if (!email.contains('@')) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Please enter a password.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final exists = await DBHelper.instance.emailExists(email);
      if (!mounted) return;

      if (exists) {
        _showMessage('This email is already registered.');
        return;
      }

      final user = AppUser(
        fullName: name,
        email: email,
        password: password,
      );

      await DBHelper.instance.registerUser(user);

      if (!mounted) return;

      _showMessage('Account created successfully. Please log in.');
      Navigator.pushReplacementNamed(context, '/login');
    } on DatabaseException catch (e) {
      if (!mounted) return;
      if (e.isUniqueConstraintError()) {
        _showMessage('This email is already registered.');
      } else {
        _showMessage('Registration failed. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage('Registration failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
