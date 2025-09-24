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
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Election Login"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.how_to_vote,
                      size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 20),
                  const Text(
                    "Student Election Portal",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      hintText: "Enter Student ID",
                      errorText: _errorMessage,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _login,
                    icon: const Icon(Icons.login),
                    label: const Text("Login"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.deepPurple,
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
