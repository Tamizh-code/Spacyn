import 'package:flutter/material.dart';
import 'create_group_page.dart';
import 'group_chat_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  // Temporary group list (local)
  List<Map<String, String>> groups = [
    {"name": "CSE - 2nd Year", "desc": "All classmates here"},
    {"name": "AI Club", "desc": "Discuss AI/ML topics"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Groups"),
        backgroundColor: Colors.deepPurple,
      ),
      body: groups.isEmpty
          ? const Center(child: Text("No groups yet. Create one!"))
          : ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.group)),
            title: Text(groups[index]["name"]!),
            subtitle: Text(groups[index]["desc"] ?? ""),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GroupChatPage(groupName: groups[index]["name"]!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final newGroup = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGroupPage()),
          );
          if (newGroup != null) {
            setState(() {
              groups.add(newGroup);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
