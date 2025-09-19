import 'package:flutter/material.dart';
import 'models.dart';

class PartiesPage extends StatefulWidget {
  final String studentId;
  const PartiesPage({super.key, required this.studentId});

  @override
  State<PartiesPage> createState() => _PartiesPageState();
}

class _PartiesPageState extends State<PartiesPage> {
  final List<Party> _parties = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _createParty() {
    if (!widget.studentId.startsWith("FY")) { // simulate Final Year check
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only Final Year students can create parties")),
      );
      return;
    }

    if (_parties.any((p) => p.leaderId == widget.studentId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only create one party")),
      );
      return;
    }

    String name = _nameController.text.trim();
    String desc = _descController.text.trim();

    if (name.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter party name & description")),
      );
      return;
    }

    setState(() {
      _parties.add(Party(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: desc,
        leaderId: widget.studentId,
      ));
      _nameController.clear();
      _descController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Party Name"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _createParty,
                  child: const Text("Create Party"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _parties.length,
              itemBuilder: (_, index) {
                final p = _parties[index];
                return Card(
                  child: ListTile(
                    title: Text(p.name),
                    subtitle: Text(p.description),
                    trailing: Text("Leader: ${p.leaderId}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
