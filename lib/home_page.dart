import 'package:flutter/material.dart';
import 'package:project/pages/post_page.dart';
import 'pages/stud_media_page.dart';
import 'pages/other_functions_page.dart';
import 'pages/updates_page.dart';
import 'pages/day_updates_page.dart';
import 'pages/more_page.dart';
import 'pages/profile_page.dart';
import 'pages/group_page.dart';
import 'pages/alerts_page.dart';
import 'pages/events_page.dart';
import 'login_page.dart';
import 'pages/community_page.dart';
import 'pages/properties_page.dart';

class HomePage extends StatefulWidget {
  final String userEmail;

  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false; // state for dark mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sραcуи",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AlertsPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _openSettings(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text("Hello 👋",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
              Text(widget.userEmail, style: const TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 25),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 25),

              // Quick Access Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildCircleButton(context, Icons.person, "Profile",
                      ProfilePage(
                        userEmail: widget.userEmail,
                        isDarkMode: isDarkMode,
                        onToggleTheme: (value) {
                          setState(() => isDarkMode = value);
                        },
                      )),
                  buildCircleButton(context, Icons.people, "Group", GroupPage()),
                  buildCircleButton(context, Icons.event, "Events", EventsPage()),
                ],
              ),
              const SizedBox(height: 25),

              // Feature Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  buildFeatureCard(context, "Stud Media", Icons.school, Colors.purple,
                      StudMediaHomePage(userEmail: widget.userEmail)),
                  buildFeatureCard(context, "Posts", Icons.plus_one_rounded, Colors.blue, PostPage()),
                  buildFeatureCard(context, "Other Functions", Icons.extension, Colors.orange, OtherFunctionsPage()),
                  buildFeatureCard(context, "Updates on Dept", Icons.update, Colors.green, UpdatesPage()),
                  buildFeatureCard(context, "Day Updates", Icons.today, Colors.red, DayUpdatesPage()),
                  buildFeatureCard(context, "More", Icons.more_horiz, Colors.grey, MorePage()),
                ],
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 3,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PropertiesPage()));
                },
                icon: const Icon(Icons.folder, color: Colors.grey),
                label: const Text("Properties", style: TextStyle(color: Colors.grey)),
              ),

              // 🔹 Center FAB always goes Home
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(userEmail: widget.userEmail)),
                        (route) => false,
                  );
                },
                backgroundColor: Colors.deepPurple,
                elevation: 3,
                child: const Icon(Icons.home, color: Colors.white),
              ),

              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunityPage(currentUser: widget.userEmail)),
                  );
                },
                icon: const Icon(Icons.group, color: Colors.grey),
                label: const Text("Community", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Circle Button Widget
  Widget buildCircleButton(BuildContext context, IconData icon, String label, Widget page) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.deepPurple.shade50,
            child: Icon(icon, size: 30, color: Colors.deepPurple),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // Feature Card Widget
  Widget buildFeatureCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // Settings Bottom Sheet
  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Account"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text("Privacy"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Logout", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
