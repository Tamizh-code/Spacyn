import 'package:flutter/material.dart';
import '../home_page.dart';
import '../pages/properties_page.dart';
import '../pages/community_page.dart';

Widget globalBottomNavBar(BuildContext context, String userEmail) {
  return BottomAppBar(
    color: Colors.white,
    elevation: 3,
    shape: const CircularNotchedRectangle(),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 🔹 Left: Properties
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PropertiesPage()),
              );
            },
            icon: const Icon(Icons.folder, color: Colors.grey),
            label: const Text("Properties", style: TextStyle(color: Colors.grey)),
          ),

          // 🔹 Center: Home FAB
          FloatingActionButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage(userEmail: userEmail)),
                    (route) => false,
              );
            },
            backgroundColor: Colors.deepPurple,
            elevation: 3,
            child: const Icon(Icons.home, color: Colors.white),
          ),

          // 🔹 Right: Community
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CommunityPage(currentUser: userEmail)),
              );
            },
            icon: const Icon(Icons.group, color: Colors.grey),
            label: const Text("Community", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    ),
  );
}
