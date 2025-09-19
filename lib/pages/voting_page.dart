import 'package:flutter/material.dart';
import 'models.dart';

class VotingPage extends StatefulWidget {
  final String studentId;
  const VotingPage({super.key, required this.studentId});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final List<Candidate> _candidates = [
    Candidate(studentId: "1001", name: "Alice", role: "President", partyId: "P1"),
    Candidate(studentId: "1002", name: "Bob", role: "President", partyId: "P2"),
  ];
  final Map<String, String> _votes = {}; // voterId → candidateId

  void _vote(Candidate c) {
    if (_votes.containsKey(widget.studentId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already voted")),
      );
      return;
    }

    setState(() => _votes[widget.studentId] = c.studentId);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Vote casted for ${c.name}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _candidates.length,
        itemBuilder: (_, i) {
          final c = _candidates[i];
          return Card(
            child: ListTile(
              title: Text("${c.name} - ${c.role}"),
              subtitle: Text("Party: ${c.partyId}"),
              trailing: IconButton(
                icon: const Icon(Icons.how_to_vote, color: Colors.blue),
                onPressed: () => _vote(c),
              ),
            ),
          );
        },
      ),
    );
  }
}
