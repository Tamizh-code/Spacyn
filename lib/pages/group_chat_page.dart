import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  final String groupName;
  final List<String> members;
  final Function(String) onAddMember;

  const GroupChatPage({
    super.key,
    required this.groupName,
    required this.members,
    required this.onAddMember,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  late String groupName;
  String groupDescription = "This is a new group";
  late List<String> members;

  @override
  void initState() {
    super.initState();
    groupName = widget.groupName;
    members = List.from(widget.members);
  }

  void _showGroupInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final nameController = TextEditingController(text: groupName);
        final descController = TextEditingController(text: groupDescription);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Group Info",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Group Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: "Group Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text("Members",
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(members[index]),
                      subtitle:
                      index == 0 ? const Text("Admin") : const Text("Member"),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        groupName = nameController.text;
                        groupDescription = descController.text;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _showAddMemberDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Member"),
          content: TextField(
            controller: controller,
            decoration:
            const InputDecoration(hintText: "Enter student name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    members.add(controller.text);
                  });
                  widget.onAddMember(controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _exitGroup() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You exited $groupName")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName),
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "info") _showGroupInfo();
              if (value == "add") _showAddMemberDialog();
              if (value == "exit") _exitGroup();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "info", child: Text("Group Info")),
              const PopupMenuItem(value: "add", child: Text("Add Member")),
              const PopupMenuItem(value: "exit", child: Text("Exit Group")),
            ],
          )
        ],
      ),
      body: Center(
        child: Text(
          "Chat messages in $groupName will appear here",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
