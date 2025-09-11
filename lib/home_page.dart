import 'package:flutter/material.dart';

// yeh imports aapke pages ke liye hain
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
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section with Greetings and Logout
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "D",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.grey),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    tooltip: 'Logout',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Hello,",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.normal),
              ),
              const Text(
                "Welcome Back.",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // 🔹 Search Field
              TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
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
                  buildFeatureCard(context, "Stud Media", Icons.school, Colors.purple, StudMediaPage()),
                  buildFeatureCard(context, "Posts", Icons.post_add, Colors.blue, PostsPage()),
                  buildFeatureCard(context, "Other Functions", Icons.extension, Colors.orange, OtherFunctionsPage()),
                  buildFeatureCard(context, "Updates on Dept", Icons.update, Colors.green, UpdatesPage()),
                  buildFeatureCard(context, "Day to Day Updates", Icons.today, Colors.red, DayUpdatesPage()),
                  buildFeatureCard(context, "More", Icons.more_horiz, Colors.grey, MorePage()),
                ],
              ),
            ],
          ),
        ),
      ),

      // 🔹 Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.folder, color: Colors.grey),
                label: const Text("Properties", style: TextStyle(color: Colors.grey)),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostPage()),
                  );
                },
                backgroundColor: const Color(0xFFE53935),
                elevation: 0,
                child: const Icon(Icons.add, color: Colors.white),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.group, color: Colors.grey),
                label: const Text("Community", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
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
            backgroundColor: Colors.grey[200],
            child: Icon(icon, size: 30, color: Colors.black),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }

  // Helper: Feature Card
  Widget buildFeatureCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
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
