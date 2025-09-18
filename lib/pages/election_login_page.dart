import 'package:flutter/material.dart';
import 'election_dashboard.dart';

class ElectionLoginPage extends StatefulWidget {
  const ElectionLoginPage({super.key});

  @override
  State<ElectionLoginPage> createState() => _ElectionLoginPageState();
}

class _ElectionLoginPageState extends State<ElectionLoginPage> {
  final TextEditingController _idController = TextEditingController();
  String? _errorMessage;

  void _login() {
    String enteredId = _idController.text.trim();

    if (enteredId.isEmpty) {
      setState(() => _errorMessage = "Please enter your Student ID");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ElectionDashboard(studentId: enteredId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Election Login")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter Student ID", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: "Student ID",
                  errorText: _errorMessage,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _login,
                icon: const Icon(Icons.login),
                label: const Text("Login"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 45),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
