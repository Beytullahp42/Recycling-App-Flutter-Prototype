import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_calls.dart';
import '../routes.dart';
import '../components/unfocus_wrapper.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  DateTime? _birthdate;

  bool _isLoading = false;
  String? _error;

  Future<void> _handleCreateProfile() async {
    if (!_formKey.currentState!.validate() || _birthdate == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await ApiCalls.createProfile({
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'username': _usernameController.text.trim(),
      'birthdate': _birthdate!.toIso8601String(),
      'bio': _bioController.text.trim(),
    });

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result == "success") {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } else {
      setState(() => _error = result);
    }
  }

  Future<void> _pickBirthdate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnfocusOnTap(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Create Profile", style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (val) => val == null || val.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: _pickBirthdate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Birthdate",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _birthdate != null
                            ? DateFormat.yMMMMd().format(_birthdate!)
                            : "Tap to select",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: "Bio (optional)",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _handleCreateProfile,
                      child: const Text("Create Profile"),
                    ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
