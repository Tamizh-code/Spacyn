import 'package:flutter/material.dart';
import 'election_page.dart';

class MorePage extends StatelessWidget {
  final String studentId; // ✅ Passed from login/profile

  const MorePage({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("More Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ElectionPage(studentId: studentId),
              ),
            );
          },
          child: const Text("Open Election Portal"),
        ),
      ),
    );
  }
}
