import 'package:flutter/material.dart';
import 'models.dart';

class CandidatesPage extends StatefulWidget {
  final String studentId;
  const CandidatesPage({super.key, required this.studentId});

  @override
  State<CandidatesPage> createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  final List<Candidate> _candidates = [];
  final TextEditingController _nameController = TextEditingController();
  String _role = "President";

  final List<String> _roles = [
    "President",
    "Vice President",
    "Secretary",
    "Vice Secretary",
  ];

  void _nominate() {
    String name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (_candidates.any((c) => c.studentId == widget.studentId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are already nominated")),
      );
      return;
    }

    setState(() {
      _candidates.add(Candidate(
        studentId: widget.studentId,
        name: name,
        role: _role,
        partyId: "TEMP_PARTY",
      ));
      _nameController.clear();
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
                  decoration: const InputDecoration(labelText: "Your Name"),
                ),
                DropdownButton<String>(
                  value: _role,
                  onChanged: (val) => setState(() => _role = val!),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                ),
                ElevatedButton(
                  onPressed: _nominate,
                  child: const Text("Nominate Yourself"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _candidates.length,
              itemBuilder: (_, i) {
                final c = _candidates[i];
                return Card(
                  child: ListTile(
                    title: Text("${c.name} (${c.role})"),
                    subtitle: Text("ID: ${c.studentId}"),
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
