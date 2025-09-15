import 'package:flutter/material.dart';

class StudentInfoPage extends StatelessWidget {
  final String username;

  const StudentInfoPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> student = {
      "department": "CSE",
      "year": "2nd Year",
      "bio": "Loves coding and AI projects.",
      "avatar": "👤"
    };

    return Scaffold(
      appBar: AppBar(title: Text("$username's Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 40, child: Text(student["avatar"], style: const TextStyle(fontSize: 40))),
            const SizedBox(height: 20),
            Text(username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Department: ${student['department']}"),
            Text("Year: ${student['year']}"),
            const SizedBox(height: 10),
            Text(student["bio"]),
          ],
        ),
      ),
    );
  }
}
