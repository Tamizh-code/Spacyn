import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  final String groupName;
  final List<String> members;
  final void Function(String newMember)? onAddMember;

  const GroupChatPage({
    super.key,
    required this.groupName,
    required this.members,
    this.onAddMember,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final _messages = <Map<String, String>>[];
  final _controller = TextEditingController();

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() => _messages.add({'from': 'You', 'text': text.trim()}));
    _controller.clear();
  }

  void _showAddMemberDialog() {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add member'),
        content: TextField(controller: c, decoration: const InputDecoration(hintText: 'Username')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = c.text.trim();
              if (name.isNotEmpty) {
                widget.onAddMember?.call(name);
                Navigator.pop(context);
              }
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
        title: Text(widget.groupName),
        actions: [IconButton(icon: const Icon(Icons.person_add), onPressed: _showAddMemberDialog)],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Text('No messages yet. Members: ${widget.members.join(', ')}'))
                : ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[_messages.length - 1 - i];
                return ListTile(title: Text(msg['from'] ?? ''), subtitle: Text(msg['text'] ?? ''));
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Message'),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: () => _sendMessage(_controller.text))
              ],
            ),
          )
        ],
      ),
    );
  }
}
