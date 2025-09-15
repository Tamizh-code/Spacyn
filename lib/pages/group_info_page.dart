import 'package:flutter/material.dart';
import 'student_info_page.dart';
import 'group_chat_page.dart';
import 'community_page.dart'; // import Group

class GroupInfoPage extends StatefulWidget {
  final Group group;
  final String currentUser;
  final Function(Group) onUpdate;
  final VoidCallback onDelete;
  final Function(String) onRemoveMember;

  const GroupInfoPage({
    super.key,
    required this.group,
    required this.currentUser,
    required this.onUpdate,
    required this.onDelete,
    required this.onRemoveMember,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  late Group group;

  @override
  void initState() {
    super.initState();
    group = widget.group;
  }

  void _editGroup() {
    final nameController = TextEditingController(text: group.name);
    final descController = TextEditingController(text: group.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Group"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Group Name")),
            TextField(controller: descController, decoration: const InputDecoration(labelText: "Description")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          FilledButton(
            onPressed: () {
              setState(() {
                group.name = nameController.text;
                group.description = descController.text;
              });
              widget.onUpdate(group);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Group"),
        content: const Text("Are you sure you want to delete this group?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          FilledButton(
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GroupChatPage(groupName: group.name, members: group.members),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.currentUser == group.admin;

    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        backgroundColor: group.color,
        actions: [
          if (isAdmin)
            IconButton(icon: const Icon(Icons.edit), onPressed: _editGroup),
          if (isAdmin)
            IconButton(icon: const Icon(Icons.delete), onPressed: _confirmDelete),
          IconButton(icon: const Icon(Icons.chat), onPressed: _openChat),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ListTile(
            title: Text(group.description.isEmpty ? "No description" : group.description),
            subtitle: Text("Admin: ${group.admin}"),
          ),
          const Divider(),
          const Text("Members", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ...group.members.map(
                (m) => ListTile(
              title: Text(m),
              trailing: isAdmin && m != group.admin
                  ? IconButton(icon: const Icon(Icons.remove_circle, color: Colors.red), onPressed: () => widget.onRemoveMember(m))
                  : null,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentInfoPage(username: m)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
