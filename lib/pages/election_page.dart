import 'package:flutter/material.dart';
import 'results_page.dart';

class Party {
  String name;
  int votes;
  String creatorId; // president
  String? vicePresidentId;
  String? secretaryId;
  String? jointSecretaryId;

  Party({
    required this.name,
    required this.creatorId,
    this.votes = 0,
    this.vicePresidentId,
    this.secretaryId,
    this.jointSecretaryId,
  });
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

  // Dummy function: in real app this would come from DB
  bool _isFinalYear(String id) {
    return id.startsWith("4"); // e.g., roll starting with 4 → final year
  }

  void _createParty() {
    String name = _partyController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a Party name")),
      );
      return;
    }

    if (!_isFinalYear(widget.studentId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only Final Year students can create a party")),
      );
      return;
    }

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

  void _assignRole(Party party, String role) {
    if (widget.studentId == party.creatorId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You are already President")),
      );
      return;
    }

    setState(() {
      switch (role) {
        case "Vice President":
          party.vicePresidentId = widget.studentId;
          break;
        case "Secretary":
          party.secretaryId = widget.studentId;
          break;
        case "Joint Secretary":
          party.jointSecretaryId = widget.studentId;
          break;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You joined ${party.name} as $role")),
    );
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
                  child: ExpansionTile(
                    title: Text(party.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Votes: ${party.votes}"),
                    children: [
                      ListTile(
                        title: Text("President: ${party.creatorId}"),
                      ),
                      ListTile(
                        title: Text("Vice President: ${party.vicePresidentId ?? 'Not Assigned'}"),
                        trailing: ElevatedButton(
                          onPressed: () => _assignRole(party, "Vice President"),
                          child: const Text("Join"),
                        ),
                      ),
                      ListTile(
                        title: Text("Secretary: ${party.secretaryId ?? 'Not Assigned'}"),
                        trailing: ElevatedButton(
                          onPressed: () => _assignRole(party, "Secretary"),
                          child: const Text("Join"),
                        ),
                      ),
                      ListTile(
                        title: Text("Joint Secretary: ${party.jointSecretaryId ?? 'Not Assigned'}"),
                        trailing: ElevatedButton(
                          onPressed: () => _assignRole(party, "Joint Secretary"),
                          child: const Text("Join"),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.how_to_vote, color: Colors.white),
                        label: const Text("Vote"),
                        onPressed: () => _vote(party),
                      ),
                    ],
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
