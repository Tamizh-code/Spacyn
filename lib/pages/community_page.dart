import 'package:flutter/material.dart';
import 'group_info_page.dart';
import 'group_chat_page.dart';

class Group {
  String id;
  String name;
  String description;
  String icon;
  Color color;
  List<String> members;
  String admin;

  Group({
    required this.id,
    required this.name,
    this.description = '',
    this.icon = '👥',
    Color? color,
    List<String>? members,
    required this.admin,
  })  : color = color ?? Colors.deepPurple,
        members = members ?? [];
}

class CommunityPage extends StatefulWidget {
  final String currentUser;
  const CommunityPage({super.key, this.currentUser = "Guest"});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Group> _groups = [];

  String _search = '';

  String _generateId() => DateTime.now().millisecondsSinceEpoch.toString();

  void _createGroup(String name, {String icon = '👥', Color? color}) {
    final newGroup = Group(
      id: _generateId(),
      name: name,
      icon: icon,
      color: color ?? Colors.deepPurple,
      members: [widget.currentUser],
      admin: widget.currentUser,
    );
    setState(() => _groups.insert(0, newGroup));
  }

  void _deleteGroup(Group g) => setState(() => _groups.removeWhere((x) => x.id == g.id));

  void _updateGroup(Group updated) {
    final idx = _groups.indexWhere((g) => g.id == updated.id);
    if (idx >= 0) setState(() => _groups[idx] = updated);
  }

  void _addMember(Group g, String username) {
    if (!g.members.contains(username)) {
      setState(() => g.members.add(username));
      _updateGroup(g);
    }
  }

  void _removeMember(Group g, String username) {
    if (g.members.contains(username)) {
      setState(() => g.members.remove(username));
      if (g.admin == username) {
        if (g.members.isNotEmpty) {
          g.admin = g.members.first;
        } else {
          _deleteGroup(g);
          return;
        }
      }
      _updateGroup(g);
    }
  }

  List<Group> get _filteredGroups {
    if (_search.trim().isEmpty) return _groups;
    final lower = _search.toLowerCase();
    return _groups
        .where((g) =>
    g.name.toLowerCase().contains(lower) ||
        g.description.toLowerCase().contains(lower))
        .toList();
  }

  void _showCreateGroupDialog() {
    final controller = TextEditingController();
    String icon = '👥';
    Color color = Colors.deepPurple;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Create Group'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: controller, decoration: const InputDecoration(hintText: 'Group name')),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Icon:'),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: icon,
                      items: ['👥', '💬', '📚', '💻', '🤖', '🎮', '🎓']
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, style: const TextStyle(fontSize: 20)),
                      ))
                          .toList(),
                      onChanged: (v) => setDialogState(() => icon = v ?? '👥'),
                    ),
                    const SizedBox(width: 12),
                    const Text('Color:'),
                    const SizedBox(width: 8),
                    DropdownButton<Color>(
                      value: color,
                      items: [Colors.deepPurple, Colors.indigo, Colors.teal, Colors.orange, Colors.pink, Colors.brown]
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Container(width: 24, height: 16, color: c),
                      ))
                          .toList(),
                      onChanged: (c) => setDialogState(() => color = c ?? Colors.deepPurple),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              FilledButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    _createGroup(name, icon: icon, color: color);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid group name')));
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Groups'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Search groups',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: _filteredGroups.isEmpty
          ? const Center(child: Text('No groups yet.'))
          : ListView.builder(
        itemCount: _filteredGroups.length,
        itemBuilder: (context, i) {
          final g = _filteredGroups[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: g.color, child: Text(g.icon, style: const TextStyle(fontSize: 20))),
              title: Text(g.name),
              subtitle: Text('${g.members.length} members • ${g.description}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GroupInfoPage(
                      group: g,
                      currentUser: widget.currentUser,
                      onUpdate: (updated) => _updateGroup(updated),
                      onDelete: () => _deleteGroup(g),
                      onRemoveMember: (m) => _removeMember(g, m),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateGroupDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
