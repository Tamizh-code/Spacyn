import 'package:flutter/material.dart';
import 'election_page.dart';

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
      setState(() {
        _errorMessage = "Please enter your Student ID";
      });
      return;
    }

    // Navigate to ElectionPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ElectionPage(studentId: enteredId),
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
              const Text("Enter Student ID", style: TextStyle(fontSize: 18)),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  hintText: "Student ID",
                  errorText: _errorMessage,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _login,
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
