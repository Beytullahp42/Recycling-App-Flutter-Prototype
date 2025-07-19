import 'package:flutter/material.dart';

import '../components/unfocus_wrapper.dart';
import '../routes.dart';
import '../services/api_calls.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with RouteAware {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool firstObscure = true;
  bool secondObscure = true;
  String? _error;

  Future<void> _handleRegister() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // UI validations
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _error = "Please fill in all fields.";
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _error = "Passwords do not match.";
        _isLoading = false;
      });
      return;
    }
    if (password.length < 8) {
      setState(() {
        _error = "Password must be at least 8 characters long.";
        _isLoading = false;
      });
      return;
    }
    final success = await ApiCalls.register(email, password, confirmPassword);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    if (success == "success") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.createProfile,
            (route) => false,
      );    } else {
      setState(() {
        _error = success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnfocusOnTap(
        child: Center(
          child: Padding( // helps on small screens / keyboard up
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Register", style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: firstObscure,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(firstObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          firstObscure = !firstObscure;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: secondObscure,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(secondObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          secondObscure = !secondObscure;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _handleRegister,
                  child: const Text("Register"),
                ),
                const SizedBox(height: 10),
                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
