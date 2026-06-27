

import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // toggles between login and sign up mode
  bool isSignUp = false;

  bool isLoading = false;

  /// [Submit] - Run sign in or sign up based on current mode
  Future<void> submit() async {
    setState(() => isLoading = true);

    String? error;
    if (isSignUp) {
      // sign up needs a name as well
      error = await AuthService.instance.signUp(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      // plain login with email and password
      error = await AuthService.instance.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }

    setState(() => isLoading = false);

    // show error if something failed, the auth gate handles success navigation
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isSignUp ? 'Sign Up' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Name Field
            if (isSignUp) ...[
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
            ],

            /// Email Field
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),

            /// Password Field
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),

            /// Submit Button
            ElevatedButton(
              onPressed: isLoading ? null : submit,
              child: isLoading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(isSignUp ? 'Create Account' : 'Login'),
            ),

            /// Switch
            TextButton(
              onPressed: () => setState(() => isSignUp = !isSignUp),
              child: Text(isSignUp ? 'Already have an account? Login' : 'No account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }


}
