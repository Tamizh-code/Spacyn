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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile + Hello + Group Button + Search Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ProfilePage(userEmail: widget.userEmail)),
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
                                color: Colors.white),
                          ),
                          Text(
                            widget.userEmail,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    // Group Button
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
                    // Hidden Search Icon
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

                // Animated Search Field (hidden initially)
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

                // Feature Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),

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
                  MaterialPageRoute(builder: (_) => CommunityPage(currentUser: widget.userEmail)),
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
