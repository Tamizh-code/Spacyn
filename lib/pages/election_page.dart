import 'package:flutter/material.dart';
import 'results_page.dart';

class Party {
  String name;
  int votes;
  String creatorId;

  Party({required this.name, required this.creatorId, this.votes = 0});
}

class ElectionPage extends StatefulWidget {
  final String studentId; // comes from login page

  const ElectionPage({super.key, required this.studentId});

  @override
  _ElectionPageState createState() => _ElectionPageState();
}

class _ElectionPageState extends State<ElectionPage> {
  final List<Party> _parties = [];
  final Map<String, bool> _studentVotes = {}; // studentId → hasVoted
  final TextEditingController _partyController = TextEditingController();

  void _createParty() {
    String name = _partyController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a Party name")),
      );
      return;
    }

    // Check if this student already created a party
    if (_parties.any((p) => p.creatorId == widget.studentId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only create one party")),
      );
      return;
    }

    setState(() {
      _parties.add(Party(name: name, creatorId: widget.studentId));
      _partyController.clear();
    });
  }

  void _vote(Party party) {
    if (_studentVotes[widget.studentId] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have already voted")),
      );
      return;
    }

    setState(() {
      party.votes += 1;
      _studentVotes[widget.studentId] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Election Portal")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Logged in as: ${widget.studentId}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextField(
                  controller: _partyController,
                  decoration: const InputDecoration(
                    labelText: "Party Name",
                    border: OutlineInputBorder(),
                  ),
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
              itemBuilder: (context, index) {
                final party = _parties[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(party.name),
                    subtitle: Text("Votes: ${party.votes}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.how_to_vote, color: Colors.blue),
                      onPressed: () => _vote(party),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_parties.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultsPage(parties: _parties),
                  ),
                );
              },
              child: const Text("View Results"),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
