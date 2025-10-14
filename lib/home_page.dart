import 'dart:math';
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
import 'login_page.dart';
import 'pages/community_page.dart';
import 'pages/properties_page.dart';

class HomePage extends StatefulWidget {
  final String userEmail;
  const HomePage({super.key, required this.userEmail});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Controllers
  late final AnimationController _headerController;
  late final Animation<Offset> _headerOffset;
  late final AnimationController _searchController;
  late final Animation<double> _searchAnimation;
  late final AnimationController _cardsController;
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;

  final Set<int> _pressedCardIndices = {};
  final Duration _cardsDuration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _headerOffset = Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic));
    _headerController.forward();

    _searchController = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
    _searchAnimation = CurvedAnimation(parent: _searchController, curve: Curves.easeInOut);

    _cardsController = AnimationController(vsync: this, duration: _cardsDuration);
    _cardsController.forward();

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _pulseController.repeat(reverse: true);

    _shimmerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _shimmerController.repeat();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _headerController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _searchController.dispose();
    _cardsController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  bool get _isSearchOpen =>
      _searchController.status == AnimationStatus.completed || _searchController.value > 0.0;

  void _toggleSearchBar() {
    if (_isSearchOpen) {
      _searchController.reverse();
    } else {
      _searchController.forward();
    }
  }

  Animation<double> _cardAnimForIndex(int index, int total) {
    final double start = (index / total) * 0.6;
    final double end = (start + 0.4).clamp(0.0, 1.0);
    return CurvedAnimation(parent: _cardsController, curve: Interval(start, end, curve: Curves.easeOutBack));
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      {"title": "Stud Media", "icon": Icons.school, "color": Colors.purpleAccent, "page": StudMediaHomePage(userEmail: widget.userEmail)},
      {"title": "Posts", "icon": Icons.plus_one_rounded, "color": Colors.blueAccent, "page": PostPage()},
      {"title": "Other Functions", "icon": Icons.extension, "color": Colors.orangeAccent, "page": OtherFunctionsPage()},
      {"title": "Updates on Dept", "icon": Icons.update, "color": Colors.lightBlueAccent, "page": UpdatesPage()},
      {"title": "Day Updates", "icon": Icons.today, "color": Colors.pinkAccent, "page": DayUpdatesPage()},
      {"title": "More", "icon": Icons.more_horiz, "color": Colors.grey, "page": MorePage(studentId: widget.userEmail)},
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          SlideTransition(
            position: _headerOffset,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A0DAD), Color(0xFF1E90FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(color: Colors.black26.withOpacity(0.28), blurRadius: 12, offset: const Offset(0, 6)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: -40,
                    top: 40,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Container(
                        width: 140,
                        height: 260,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.white.withOpacity(0.02), Colors.white.withOpacity(0.0)]),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final double opacity = 0.04 + (_pulseController.value * 0.03);
                        return Container(color: Colors.transparent.withOpacity(opacity));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(radius: 22, backgroundImage: AssetImage("assets/images/Sp_logo.png")),
                                const SizedBox(width: 10),
                                const Text("Sραcуи", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                              ],
                            ),
                            Row(
                              children: [
                                // Top-right synced search icon
                                AnimatedBuilder(
                                  animation: _searchController,
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _searchController.value * 0.5,
                                      child: IconButton(
                                        icon: const Icon(Icons.search, color: Colors.white),
                                        onPressed: _toggleSearchBar,
                                      ),
                                    );
                                  },
                                ),
                                ScaleTransition(
                                  scale: Tween<double>(begin: 0.98, end: 1.02).animate(
                                    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.notifications, color: Colors.white),
                                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AlertsPage())),
                                  ),
                                ),
                                _buildSettingsMenuIcon(),
                              ],
                            ),

                          ],
                        ),
                        const SizedBox(height: 25),
                        // Glass profile card + FAB search + search bar (same as your previous code)
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 520),
                              curve: Curves.easeOut,
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.white.withOpacity(0.12), Colors.white.withOpacity(0.06)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(color: Colors.black26.withOpacity(0.18), blurRadius: 14, offset: const Offset(0, 6)),
                                  BoxShadow(color: Colors.blueAccent.withOpacity(0.03), blurRadius: 24, offset: const Offset(0, 8)),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 6))],
                                    ),
                                    child: InkWell(
                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfilePage(userEmail: widget.userEmail))),
                                      child: const CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/images/profile.jpg")),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Hello 👋", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                                        Text(widget.userEmail, style: const TextStyle(fontSize: 14, color: Colors.white70)),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GroupPage())),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrange]),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [BoxShadow(color: Colors.orangeAccent.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 6))],
                                      ),
                                      padding: const EdgeInsets.all(12),
                                      child: const Icon(Icons.group, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: -35,
                              right: 20,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 1.0, end: 1.06).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)),
                                child: FloatingActionButton(
                                  mini: true,
                                  onPressed: _toggleSearchBar,
                                  backgroundColor: Colors.white,
                                  child: AnimatedBuilder(
                                    animation: _searchController,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _searchController.value * 0.5,
                                        child: const Icon(Icons.search, color: Colors.deepPurple),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -35,
                              left: 0,
                              right: 0,
                              child: SizeTransition(
                                sizeFactor: _searchAnimation,
                                axisAlignment: -1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Material(
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(20),
                                    child: TextField(
                                      onSubmitted: (s) {},
                                      decoration: const InputDecoration(
                                        hintText: "Search...",
                                        prefixIcon: Icon(Icons.search),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                // Feature Grid same as your previous code
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final f = features[index];
                        final anim = _cardAnimForIndex(index, features.length);
                        return AnimatedBuilder(
                          animation: anim,
                          builder: (context, child) {
                            final double rotateY = (1.0 - anim.value) * (pi / 2);
                            final Matrix4 transform = Matrix4.identity()
                              ..setEntry(3, 2, 0.0018)
                              ..rotateY(rotateY);
                            final double scale = 0.90 + (anim.value * 0.12);
                            final double opacity = anim.value.clamp(0.0, 1.0);

                            return Opacity(
                              opacity: opacity,
                              child: Transform(
                                transform: transform,
                                alignment: Alignment.center,
                                child: Transform.scale(
                                  scale: scale,
                                  child: _buildFeatureCardEnhanced(
                                    index: index,
                                    title: f["title"] as String,
                                    icon: f["icon"] as IconData,
                                    color: f["color"] as Color,
                                    page: f["page"] as Widget,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      childCount: features.length,
                    ),
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
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white.withOpacity(0.96),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.folder_outlined, color: Color(0xFF00CED1)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertiesPage())),
              ),
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(userEmail: widget.userEmail)),
                        (route) => false,
                  );
                },
                backgroundColor: Colors.deepPurple,
                child: const Icon(Icons.home, color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.group, color: Color(0xFFFFA500)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommunityPage(currentUser: widget.userEmail))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCardEnhanced({
    required int index,
    required String title,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    final bool isPressed = _pressedCardIndices.contains(index);

    final shimmer = AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final double w = bounds.width;
            final double pos = (_shimmerController.value * 2.0) - 0.5;
            return LinearGradient(
              colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.35), Colors.white.withOpacity(0.0)],
              stops: [max(0.0, pos), min(1.0, pos + 0.18), min(1.0, pos + 0.36)],
              begin: Alignment(-1.0, -0.3),
              end: Alignment(1.0, 0.3),
            ).createShader(Rect.fromLTWH(0, 0, w, bounds.height));
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: color.withOpacity(0.22), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Icon(icon, size: 34, color: Colors.white),
      ),
    );

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressedCardIndices.add(index)),
      onTapUp: (_) async {
        setState(() => _pressedCardIndices.remove(index));
        await Future.delayed(const Duration(milliseconds: 80));
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      onTapCancel: () => setState(() => _pressedCardIndices.remove(index)),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        scale: isPressed ? 0.96 : 1.0,
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(colors: [Colors.white.withOpacity(0.98), Colors.white.withOpacity(0.95)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            boxShadow: [
              BoxShadow(color: Colors.black12.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 6)),
              BoxShadow(color: color.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final double scale = 0.98 + (_pulseController.value * 0.08);
                  final double glow = 0.06 + (_pulseController.value * 0.06);
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [color, color.withOpacity(0.7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        boxShadow: [BoxShadow(color: color.withOpacity(glow), blurRadius: 18, spreadRadius: 1, offset: const Offset(0, 8))],
                      ),
                      child: shimmer,
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsMenuIcon() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings, color: Colors.white),
      onSelected: (value) {},
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem(value: 'Logout', child: Text('Logout')),
        PopupMenuItem(value: 'Privacy', child: Text('Privacy Policy')),
        PopupMenuItem(value: 'Feedback', child: Text('Feedback')),
        PopupMenuItem(value: 'About', child: Text('About')),
      ],
    );
  }
}
