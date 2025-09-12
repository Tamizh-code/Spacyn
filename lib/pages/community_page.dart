import 'package:flutter/material.dart';
import 'group_chat_page.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  List<Map<String, dynamic>> groups = [
    {
      "name": "CSE - 2nd Year",
      "members": ["Alice", "Bob", "Charlie"],
    },
    {
      "name": "AI Club",
      "members": ["David", "Eva"],
    },
  ];

  void createGroup(String groupName) {
    setState(() {
      groups.add({"name": groupName, "members": []});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Groups"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.group)),
            title: Text(groups[index]["name"]),
            subtitle: Text("${groups[index]["members"].length} members"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChatPage(
                    groupName: groups[index]["name"],
                    members: List<String>.from(groups[index]["members"]),
                    onAddMember: (newMember) {
                      setState(() {
                        groups[index]["members"].add(newMember);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateGroupDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Group"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter group name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  createGroup(controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }
}
