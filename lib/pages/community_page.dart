// lib/pages/community_page.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------
// Models
// ---------------------------
class GroupModel {
  String id;
  String name;
  String description;
  String adminId;
  List<String> members;
  List<ChatMessage> messages;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.adminId,
    required this.members,
    required this.messages,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'adminId': adminId,
    'members': members,
    'messages': messages.map((m) => m.toJson()).toList(),
  };

  factory GroupModel.fromJson(Map<String, dynamic> j) => GroupModel(
    id: j['id'],
    name: j['name'],
    description: j['description'],
    adminId: j['adminId'],
    members: List<String>.from(j['members'] ?? []),
    messages: (j['messages'] as List? ?? [])
        .map((x) => ChatMessage.fromJson(Map<String, dynamic>.from(x)))
        .toList(),
  );
}

class ChatMessage {
  String id;
  String senderId;
  String text;
  int timestamp;

  ChatMessage(
      {required this.id,
        required this.senderId,
        required this.text,
        required this.timestamp});

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'text': text,
    'timestamp': timestamp,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
    id: j['id'],
    senderId: j['senderId'],
    text: j['text'],
    timestamp: j['timestamp'],
  );
}

// ---------------------------
// CommunityPage
// ---------------------------
class CommunityPage extends StatefulWidget {
  final String currentUser;

  const CommunityPage({super.key, required this.currentUser});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  static const _storageKey = 'community_groups_v1';
  List<GroupModel> groups = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => loading = true);
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_storageKey);
    if (raw != null) {
      try {
        final arr = jsonDecode(raw) as List;
        groups = arr
            .map((e) => GroupModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (_) {
        groups = [];
      }
    }

    if (groups.isEmpty) {
      final sample = GroupModel(
        id: 'g-${DateTime.now().millisecondsSinceEpoch}',
        name: 'Flutter Devs',
        description: 'A jellyfish-blue group for Flutter learners.',
        adminId: widget.currentUser,
        members: [widget.currentUser],
        messages: [
          ChatMessage(
              id: 'm1',
              senderId: widget.currentUser,
              text: 'Welcome! Create groups and invite your classmates.',
              timestamp: DateTime.now().millisecondsSinceEpoch - 600000),
        ],
      );
      groups = [sample];
      await _saveToDisk();
    }
    setState(() => loading = false);
  }

  Future<void> _saveToDisk() async {
    final sp = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(groups.map((g) => g.toJson()).toList());
    await sp.setString(_storageKey, jsonStr);
  }

  String _displayName(String id) {
    final part = id.split('@').first;
    if (part.isEmpty) return id;
    return part[0].toUpperCase() + part.substring(1);
  }

  Future<void> _createGroup() async {
    final result = await showDialog<GroupModel?>(
      context: context,
      builder: (ctx) => _CreateGroupDialog(creatorId: widget.currentUser),
    );
    if (result != null) {
      setState(() => groups.insert(0, result));
      await _saveToDisk();
    }
  }

  Future<void> _openGroup(GroupModel group) async {
    final res = await Navigator.push<GroupModel?>(
      context,
      MaterialPageRoute(
          builder: (_) =>
              GroupChatPage(group: group, currentUser: widget.currentUser)),
    );
    if (res != null) {
      final idx = groups.indexWhere((g) => g.id == res.id);
      if (idx != -1) {
        setState(() => groups[idx] = res);
      } else {
        setState(() => groups.removeWhere((g) => g.id == res.id));
      }
      await _saveToDisk();
    }
  }

  Future<void> _deleteGroup(GroupModel g) async {
    final ok = await showDialog<bool?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete group'),
        content: Text('Delete "${g.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      setState(() => groups.removeWhere((x) => x.id == g.id));
      await _saveToDisk();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFF42A5F5), Color(0xFF0D47A1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.group, color: Color(0xFF0D47A1))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Community',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                                'Groups created by students — you are ${_displayName(widget.currentUser)}',
                                style: const TextStyle(color: Colors.white70)),
                          ]),
                    ),
                    IconButton(
                      onPressed: _createGroup,
                      icon: const Icon(Icons.add_box_outlined, color: Colors.white),
                      tooltip: 'Create group',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : groups.isEmpty
                    ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.group_off, size: 64, color: Colors.white70),
                        SizedBox(height: 8),
                        Text('No groups yet',
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ))
                    : RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.transparent,
                  onRefresh: _loadGroups,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    itemCount: groups.length,
                    itemBuilder: (ctx, i) {
                      final g = groups[i];
                      final isAdmin = g.adminId == widget.currentUser;
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 6,
                        margin:
                        const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () => _openGroup(g),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.group,
                                      color: const Color(0xFF0D47A1)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(g.name,
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold))),
                                            if (isAdmin)
                                              Container(
                                                padding:
                                                const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 8,
                                                    vertical: 4),
                                                decoration: BoxDecoration(
                                                    color:
                                                    Colors.orangeAccent,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                                child: const Text(
                                                    'Admin',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.black)),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          g.description,
                                          style: const TextStyle(
                                              color: Colors.black54),
                                          maxLines: 2,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(children: [
                                          const Icon(Icons.person,
                                              size: 14,
                                              color: Colors.black45),
                                          const SizedBox(width: 6),
                                          Text('${g.members.length} members',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                  Colors.black45)),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.message,
                                              size: 14,
                                              color: Colors.black45),
                                          const SizedBox(width: 6),
                                          Text('${g.messages.length}',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                  Colors.black45)),
                                        ]),
                                      ]),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (v) async {},
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                        value: 'info', child: Text('Info')),
                                    PopupMenuItem(
                                        value: 'edit', child: Text('Edit')),
                                    PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createGroup,
        label: const Text('Create Group'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

// ---------------------------
// Create Group Dialog
// ---------------------------
class _CreateGroupDialog extends StatefulWidget {
  final String creatorId;
  const _CreateGroupDialog({required this.creatorId});

  @override
  State<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<_CreateGroupDialog> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _memberCtrl = TextEditingController();
  List<String> _members = [];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _memberCtrl.dispose();
    super.dispose();
  }

  void _addMemberToList() {
    final t = _memberCtrl.text.trim();
    if (t.isEmpty) return;
    if (!_members.contains(t)) {
      setState(() {
        _members.add(t);
        _memberCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Group'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Group name')),
            const SizedBox(height: 8),
            TextField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                  child: TextField(
                      controller: _memberCtrl,
                      decoration:
                      const InputDecoration(hintText: 'Add member email'))),
              IconButton(icon: const Icon(Icons.add), onPressed: _addMemberToList),
            ]),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: _members
                  .map((m) => Chip(
                  label: Text(m),
                  onDeleted: () => setState(() => _members.remove(m))))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter group name')));
              return;
            }
            final id =
                'g-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}';
            final allMembers = [widget.creatorId] + _members.toSet().toList();
            final newGroup = GroupModel(
                id: id,
                name: name,
                description: _descCtrl.text.trim(),
                adminId: widget.creatorId,
                members: allMembers,
                messages: []);
            Navigator.pop(context, newGroup);
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

// ---------------------------
// Group Chat Page
// ---------------------------
class GroupChatPage extends StatefulWidget {
  final GroupModel group;
  final String currentUser;

  const GroupChatPage({super.key, required this.group, required this.currentUser});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  late GroupModel group;
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    group = widget.group;
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final msg = ChatMessage(
        id: 'm-${DateTime.now().millisecondsSinceEpoch}',
        senderId: widget.currentUser,
        text: text,
        timestamp: DateTime.now().millisecondsSinceEpoch);
    setState(() {
      group.messages.add(msg);
      _msgCtrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent + 60,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _leaveGroup() async {
    final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Leave Group'),
          content: const Text('Are you sure you want to leave this group?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Leave')),
          ],
        ));
    if (ok == true) {
      group.members.remove(widget.currentUser);
      Navigator.pop(context, group);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(group.name),
          actions: [
            IconButton(onPressed: _leaveGroup, icon: const Icon(Icons.exit_to_app)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(12),
                  itemCount: group.messages.length,
                  itemBuilder: (ctx, i) {
                    final m = group.messages[i];
                    final isMe = m.senderId == widget.currentUser;
                    return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: isMe ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isMe) Text(m.senderId, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                                Text(m.text),
                                Text(
                                  DateTime.fromMillisecondsSinceEpoch(m.timestamp)
                                      .toLocal()
                                      .toString()
                                      .substring(11, 16),
                                  style: const TextStyle(fontSize: 10, color: Colors.black45),
                                ),
                              ]),
                        ));
                  }),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: _msgCtrl,
                          decoration: const InputDecoration(
                              hintText: 'Type a message',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)))),
                        )),
                    const SizedBox(width: 6),
                    IconButton(onPressed: _sendMessage, icon: const Icon(Icons.send))
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

