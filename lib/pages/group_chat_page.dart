import 'package:flutter/material.dart';
import '../models/group_model.dart';

class GroupChatPage extends StatefulWidget {
  final Group group;
  final String currentUser;

  const GroupChatPage({super.key, required this.group, required this.currentUser});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Group group;

  @override
  void initState() {
    super.initState();
    group = widget.group;
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      group.messages.add({
        'sender': widget.currentUser,
        'text': text,
        'time': DateTime.now(),
      });
    });
    _controller.clear();
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isMe = msg['sender'] == widget.currentUser;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? group.color : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Text(msg['sender'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(msg['text'], style: TextStyle(color: isMe ? Colors.white : Colors.black)),
            Text(
              "${msg['time'].hour.toString().padLeft(2, '0')}:${msg['time'].minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 10, color: isMe ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
        backgroundColor: group.color,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: group.messages.length,
              itemBuilder: (_, i) => _buildMessage(group.messages[i]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                CircleAvatar(
                  backgroundColor: group.color,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
