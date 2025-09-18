import 'package:flutter/material.dart';
import '../models/group_model.dart';
import 'group_info_page.dart';


class CommunityPage extends StatefulWidget {
  final String currentUser;
  const CommunityPage({super.key, this.currentUser = "Guest"});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Group> _groups = [
    Group(
      id: 'g1',
      name: 'CSE 2nd Year',
      description: 'All second-year CSE students',
      members: ['Alice', 'Bob', 'Charlie'],
      admin: 'Alice',
      color: Colors.indigo,
      imageUrl: 'https://i.ibb.co/7N6s2mn/cse2.jpg',
    ),
    Group(
      id: 'g2',
      name: 'AI Club',
      description: 'AI projects & discussions',
      members: ['David', 'Eva'],
      admin: 'David',
      color: Colors.teal,
      imageUrl: 'https://i.ibb.co/2P2XqvS/ai-club.jpg',
    ),
  ];

  String _search = '';

  List<Group> get _filteredGroups {
    if (_search.trim().isEmpty) return _groups;
    final lower = _search.toLowerCase();
    return _groups
        .where((g) =>
    g.name.toLowerCase().contains(lower) ||
        g.description.toLowerCase().contains(lower))
        .toList();
  }

  void _createGroup(String name, {String? imageUrl, Color? color}) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newGroup = Group(
      id: id,
      name: name,
      imageUrl: imageUrl,
      color: color ?? Colors.deepPurple,
      members: [widget.currentUser],
      admin: widget.currentUser,
    );
    setState(() => _groups.insert(0, newGroup));
  }

  void _updateGroup(Group updated) {
    final idx = _groups.indexWhere((g) => g.id == updated.id);
    if (idx >= 0) setState(() => _groups[idx] = updated);
  }

  void _deleteGroup(Group g) => setState(() => _groups.removeWhere((x) => x.id == g.id));

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Group name')),
            const SizedBox(height: 8),
            TextField(controller: imageController, decoration: const InputDecoration(hintText: 'Image URL (optional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final imageUrl = imageController.text.trim().isEmpty ? null : imageController.text.trim();
              if (name.isNotEmpty) {
                _createGroup(name, imageUrl: imageUrl);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: Colors.deepPurple,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _filteredGroups.length,
        itemBuilder: (context, i) {
          final g = _filteredGroups[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GroupInfoPage(
                  group: g,
                  currentUser: widget.currentUser,
                  onUpdate: _updateGroup,
                  onDelete: () => _deleteGroup(g),
                ),
              ),
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 5,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: g.color,
                  backgroundImage: g.imageUrl != null ? NetworkImage(g.imageUrl!) : null,
                  child: g.imageUrl == null ? Text(g.name[0], style: const TextStyle(color: Colors.white, fontSize: 20)) : null,
                ),
                title: Text(g.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text('${g.members.length} members • ${g.description}', maxLines: 2, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),
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
