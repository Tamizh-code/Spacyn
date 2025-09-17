import 'package:flutter/material.dart';
import 'election_page.dart';

class ElectionLoginPage extends StatefulWidget {
  const ElectionLoginPage({super.key});

  @override
  State<ElectionLoginPage> createState() => _ElectionLoginPageState();
}

class _ElectionLoginPageState extends State<ElectionLoginPage> {
  final TextEditingController _idController = TextEditingController();

  void _login() {
    if (_idController.text.trim().isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ElectionPage(studentId: _idController.text.trim()),
        ),
      );
    }
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
              TextField(controller: _idController),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: _login, child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
