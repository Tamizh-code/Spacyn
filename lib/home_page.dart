import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Firebase logout support

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
import 'pages/community_page.dart';
import 'pages/properties_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  bool showSearchBar = false;
  late final AnimationController _controller;
  late final Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _heightAnimation = Tween<double>(begin: 0, end: 60).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleSearchBar() {
    setState(() {
      showSearchBar = !showSearchBar;
      if (showSearchBar) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A0DAD), Color(0xFF1E90FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: AssetImage("assets/images/Sp_logo.png"),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Sραcуи",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications, color: Colors.white),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => AlertsPage()),
                                  );
                                },
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.settings, color: Colors.white),
                                onSelected: (value) async {
                                  switch (value) {
                                    case 'Logout':
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Logout'),
                                          content: const Text('Are you sure you want to logout?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(ctx); // Close dialog
                                                await FirebaseAuth.instance.signOut(); // ✅ Sign out
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                                      (route) => false,
                                                );
                                              },
                                              child: const Text('Logout'),
                                            ),
                                          ],
                                        ),
                                      );
                                      break;

                                    case 'Privacy':
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Privacy Policy'),
                                          content: const Text(
                                              'Your privacy is important to us. [We value your privacy and are committed to protecting your personal information. This app collects only essential data to provide a better user experience, such as email, name, and app usage preferences. We do not share your information with third parties without your consent. All data is securely stored and used solely for app functionality, improvements, and communication. By using this app, you agree to our privacy practices.]'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Close'),
                                            )
                                          ],
                                        ),
                                      );
                                      break;

                                    case 'Feedback':
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Feedback'),
                                          content: TextField(
                                            maxLines: 3,
                                            decoration: const InputDecoration(
                                                hintText: 'Write your feedback here...'),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(ctx),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Feedback submitted!')),
                                                );
                                              },
                                              child: const Text('Submit'),
                                            ),
                                          ],
                                        ),
                                      );
                                      break;

                                    case 'About':
                                      showAboutDialog(
                                        context: context,
                                        applicationName: 'Sραcуи',
                                        applicationVersion: '1.0.0',
                                        applicationIcon: const CircleAvatar(
                                          backgroundImage:
                                          AssetImage("assets/images/spacyn_logo.png"),
                                        ),
                                        children: const [
                                          Text('This is a sample Flutter app for demonstration.'),
                                        ],
                                      );
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem(value: 'Logout', child: Text('Logout')),
                                  const PopupMenuItem(value: 'Privacy', child: Text('Privacy Policy')),
                                  const PopupMenuItem(value: 'Feedback', child: Text('Feedback')),
                                  const PopupMenuItem(value: 'About', child: Text('About')),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Profile & Search Bar Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProfilePage(userEmail: widget.userEmail)),
                            ),
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage("assets/images/profile.jpg"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Hello 👋",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  widget.userEmail,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => GroupPage()),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(Icons.group, color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: _toggleSearchBar,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(Icons.search, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),

                      // Search Bar Animation
                      SizeTransition(
                        sizeFactor: _heightAnimation.drive(Tween(begin: 0.0, end: 1.0)),
                        axisAlignment: -1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Type to search...",
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ),
                      if (showSearchBar) const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),

              // Feature Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                sliver: SliverGrid(
                  delegate: SliverChildListDelegate([
                    buildFeatureCard(context, "Stud Media", Icons.school,
                        Colors.purpleAccent, StudMediaHomePage(userEmail: widget.userEmail)),
                    buildFeatureCard(context, "Posts", Icons.plus_one_rounded,
                        Colors.blueAccent, PostPage()),
                    buildFeatureCard(context, "Other Functions", Icons.extension,
                        Colors.orangeAccent, OtherFunctionsPage()),
                    buildFeatureCard(context, "Updates on Dept", Icons.update,
                        Colors.lightBlueAccent, UpdatesPage()),
                    buildFeatureCard(context, "Day Updates", Icons.today,
                        Colors.pinkAccent, DayUpdatesPage()),
                    buildFeatureCard(context, "More", Icons.more_horiz,
                        Colors.grey, MorePage(studentId: widget.userEmail)),
                  ]),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Nav Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.folder_outlined, color: Color(0xFF00CED1)),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PropertiesPage()),
                ),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(userEmail: widget.userEmail)),
                        (route) => false,
                  );
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.home, color: Colors.deepPurple),
              ),
              IconButton(
                icon: const Icon(Icons.group, color: Color(0xFFFFA500)),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CommunityPage(currentUser: widget.userEmail)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.black45,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.85), Colors.deepPurple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              )
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 38, color: Colors.white),
                const SizedBox(height: 10),
                Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
