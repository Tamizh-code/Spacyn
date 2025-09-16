import 'package:flutter/material.dart';
import '../models/group_model.dart';
import 'group_chat_page.dart';

class GroupInfoPage extends StatefulWidget {
  final Group group;
  final String currentUser;
  final Function(Group)? onUpdate;
  final VoidCallback? onDelete;

  const GroupInfoPage({
    super.key,
    required this.group,
    required this.currentUser,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  late Group group;

  bool get isAdmin => widget.currentUser == group.admin;

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
        title: const Text('Edit Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Group Name')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              setState(() {
                group.name = nameController.text;
                group.description = descController.text;
              });
              widget.onUpdate?.call(group);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteGroup() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Group?'),
        content: const Text('Are you sure you want to delete this group?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              widget.onDelete?.call();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addMember() {
    final memberController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Member'),
        content: TextField(controller: memberController, decoration: const InputDecoration(hintText: 'Member Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = memberController.text.trim();
              if (name.isNotEmpty && !group.members.contains(name)) {
                setState(() => group.members.add(name));
                widget.onUpdate?.call(group);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Info'),
        backgroundColor: group.color,
        actions: [
          if (isAdmin) IconButton(onPressed: _editGroup, icon: const Icon(Icons.edit)),
          if (isAdmin) IconButton(onPressed: _deleteGroup, icon: const Icon(Icons.delete)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: group.imageUrl != null ? NetworkImage(group.imageUrl!) : null,
            backgroundColor: group.color,
            child: group.imageUrl == null ? Text(group.name[0], style: const TextStyle(fontSize: 40, color: Colors.white)) : null,
          ),
          const SizedBox(height: 12),
          Center(child: Text(group.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          const SizedBox(height: 6),
          Center(child: Text(group.description, style: const TextStyle(fontSize: 16, color: Colors.grey))),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Members', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              if (isAdmin)
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: _addMember,
                ),
            ],
          ),
          const SizedBox(height: 6),
          ...group.members.map((m) => ListTile(
            leading: CircleAvatar(child: Text(m[0])),
            title: Text(m),
            subtitle: m == group.admin ? const Text('Admin') : null,
          )),
          const SizedBox(height: 20),
          Center(
            child: FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupChatPage(group: group, currentUser: widget.currentUser),
                  ),
                );
              },
              child: const Text('Open Chat'),
            ),
          ),
        ],
      ),
    );
  }
}
