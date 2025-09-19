import 'package:flutter/material.dart';
import 'election_page.dart';
import 'results_page.dart';

class ElectionDashboard extends StatelessWidget {
  final String studentId;

  const ElectionDashboard({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Election Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Welcome, $studentId 👋",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            _buildButton(context, "Create / Join Party", Icons.group_add, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ElectionPage(studentId: studentId)),
              );
            }),
            _buildButton(context, "View Results", Icons.bar_chart, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ResultsPage(parties: demoParties)),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

// 🔹 Dummy parties for demo
final List<Party> demoParties = [
  Party(name: "Future Leaders", creatorId: "finalYear123", votes: 120),
  Party(name: "Unity Squad", creatorId: "finalYear456", votes: 95),
];
