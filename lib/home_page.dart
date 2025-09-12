import 'package:flutter/material.dart';

// Import all pages
import 'pages/stud_media_page.dart';
import 'pages/posts_page.dart';
import 'pages/other_functions_page.dart';
import 'pages/updates_page.dart';
import 'pages/day_updates_page.dart';
import 'pages/more_page.dart';
import 'pages/post_page.dart';
import 'pages/group_page.dart';
import 'pages/alerts_page.dart';
import 'pages/events_page.dart';
import 'pages/community_page.dart'; // ✅ Community Page

class HomePage extends StatelessWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sραcуи"),
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
                buildCircleButton(context, Icons.add_comment, "Post", PostPage()),
                buildCircleButton(context, Icons.people, "Group", GroupPage()),
                buildCircleButton(context, Icons.notifications, "Alerts", AlertsPage()),
                buildCircleButton(context, Icons.event, "Events", EventsPage()),
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
                buildFeatureCard(context, "Stud Media", Icons.school, Colors.teal,
                    StudMediaHomePage(userEmail: userEmail)),
                buildFeatureCard(context, "Posts", Icons.post_add, Colors.blue, PostsPage()),
                buildFeatureCard(context, "Other Functions", Icons.extension, Colors.orange,
                    OtherFunctionsPage()),
                buildFeatureCard(context, "Updates on Dept", Icons.update, Colors.green, UpdatesPage()),
                buildFeatureCard(context, "Day to Day Updates", Icons.today, Colors.red, DayUpdatesPage()),
                buildFeatureCard(context, "More", Icons.more_horiz, Colors.grey, MorePage()),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityPage()),
                );
              },
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
  Widget buildCircleButton(BuildContext context, IconData icon, String label, Widget page) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => page));
          },
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple.shade100,
            child: Icon(icon, size: 30, color: Colors.deepPurple),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Helper: Feature Card
  Widget buildFeatureCard(
      BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
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
