import 'package:flutter/material.dart';
import 'package:project/theme.dart'; // import theme file
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
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Sραcуи"),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AlertsPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _openSettings(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text("Hello 👋", style: Theme.of(context).textTheme.headlineMedium),
              Text(widget.userEmail,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceVariant,
                ),
              ),
              const SizedBox(height: 25),

              // Quick Access Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _circleButton(Icons.person, "Profile",
                      ProfilePage(userEmail: widget.userEmail, isDarkMode: isDarkMode, onToggleTheme: _toggleTheme)),
                  _circleButton(Icons.people, "Group", GroupPage()),
                  _circleButton(Icons.event, "Events", EventsPage()),
                ],
              ),
              const SizedBox(height: 30),

              // Features Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _featureCard("Stud Media", Icons.school, Colors.purple,
                      StudMediaHomePage(userEmail: widget.userEmail)),
                  _featureCard("Posts", Icons.add_box_outlined, Colors.blue,
                      PostPage()),
                  _featureCard("Other Functions", Icons.extension,
                      Colors.orange, OtherFunctionsPage()),
                  _featureCard("Updates on Dept", Icons.update, Colors.green,
                      UpdatesPage()),
                  _featureCard("Day Updates", Icons.today, Colors.red,
                      DayUpdatesPage()),
                  _featureCard("More", Icons.more_horiz, Colors.grey,
                      MorePage(studentId: widget.userEmail)),
                ],
              ),
            ],
          ),
        ),

        // Bottom Nav
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.folder_outlined),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PropertiesPage())),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(userEmail: widget.userEmail)),
                          (route) => false,
                    );
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.home, color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(Icons.group_outlined),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            CommunityPage(currentUser: widget.userEmail)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleTheme(bool value) {
    setState(() => isDarkMode = value);
  }

  Widget _circleButton(IconData icon, String label, Widget page) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => page)),
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(icon,
                size: 28, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _featureCard(
      String title, IconData icon, Color color, Widget page) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
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
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text("Privacy"),
              onTap: () {},
            ),
            SwitchListTile(
              value: isDarkMode,
              onChanged: _toggleTheme,
              title: const Text("Dark Mode"),
              secondary: const Icon(Icons.dark_mode_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout",
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
