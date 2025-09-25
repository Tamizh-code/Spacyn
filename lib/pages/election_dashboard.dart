import 'package:flutter/material.dart';
import 'election_page.dart';
import 'results_page.dart';

class ElectionDashboard extends StatelessWidget {
  final String studentId;

  const ElectionDashboard({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Election Dashboard"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Welcome, $studentId 👋",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 30),
            _buildCardButton(
              context,
              "Create / Join Party",
              Icons.group_add,
              Colors.deepPurple,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ElectionPage(studentId: studentId)),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildCardButton(
              context,
              "View Results",
              Icons.bar_chart,
              Colors.green,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ResultsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(BuildContext context, String text, IconData icon,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withOpacity(0.1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(height: 10),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
