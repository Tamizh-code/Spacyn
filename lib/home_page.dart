import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🆂🅿🅰🅲🆈🅽"),
        backgroundColor: Colors.deepPurple,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "+Dept",
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Search Row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Another field",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Circle Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildCircleButton(Icons.add_comment, "Post"),
                buildCircleButton(Icons.people, "Group"),
                buildCircleButton(Icons.notifications, "Alerts"),
                buildCircleButton(Icons.event, "Events"),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Grid for features
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                buildFeatureCard("Stud Media", Icons.school, Colors.purple),
                buildFeatureCard("Posts", Icons.post_add, Colors.blue),
                buildFeatureCard("Other Functions", Icons.extension, Colors.orange),
                buildFeatureCard("Updates on Dept", Icons.update, Colors.green),
                buildFeatureCard("Day to Day Updates", Icons.today, Colors.red),
                buildFeatureCard("More", Icons.more_horiz, Colors.grey),
              ],
            ),
          ],
        ),
      ),

      // 🔹 Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.folder),
              label: const Text("My Properties"),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, size: 36, color: Colors.deepPurple),
              onPressed: () {},
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.group),
              label: const Text("Community"),
            ),
            IconButton(
              icon: const Icon(Icons.smart_toy, color: Colors.deepPurple),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  // Helper: Circle Button
  Widget buildCircleButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.deepPurple.shade100,
          child: Icon(icon, size: 30, color: Colors.deepPurple),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Helper: Feature Card
  Widget buildFeatureCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
