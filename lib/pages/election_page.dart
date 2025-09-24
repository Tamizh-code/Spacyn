import 'package:flutter/material.dart';
import 'results_page.dart';

class Party {
  String name;
  String creatorId;
  String? vicePresidentId;
  String? secretaryId;
  String? jointSecretaryId;
  int presidentVotes = 0;
  int viceVotes = 0;
  int secretaryVotes = 0;
  int jointVotes = 0;

  Party({required this.name, required this.creatorId});
}

class ElectionPage extends StatefulWidget {
  final String studentId;
  const ElectionPage({super.key, required this.studentId});

  @override
  State<ElectionPage> createState() => _ElectionPageState();
}

class _ElectionPageState extends State<ElectionPage> {
  static final List<Party> _parties = [];
  final TextEditingController _partyController = TextEditingController();
  final Map<String, bool> _studentVotedPresident = {};
  final Map<String, bool> _studentVotedRoles = {};

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void _createParty() {
    String name = _partyController.text.trim();
    if (name.isEmpty) {
      _showMessage("Enter a party name");
      return;
    }
    if (_parties.any((p) => p.creatorId == widget.studentId)) {
      _showMessage("You can only create one party");
      return;
    }
    setState(() {
      _parties.add(Party(name: name, creatorId: widget.studentId));
      _partyController.clear();
    });
    _showMessage("Party '$name' created successfully!");
  }

  void _votePresident(Party party) {
    if (_studentVotedPresident[widget.studentId] == true) {
      _showMessage("You already voted for President");
      return;
    }
    setState(() {
      party.presidentVotes++;
      _studentVotedPresident[widget.studentId] = true;
    });
    _showMessage("Vote for President added!");
  }

  void _voteRole(Party party, String role) {
    if (_studentVotedRoles[widget.studentId] == true) {
      _showMessage("You already voted for a role");
      return;
    }
    setState(() {
      switch (role) {
        case "Vice President":
          party.viceVotes++;
          break;
        case "Secretary":
          party.secretaryVotes++;
          break;
        case "Joint Secretary":
          party.jointVotes++;
          break;
      }
      _studentVotedRoles[widget.studentId] = true;
    });
    _showMessage("Vote for $role added!");
  }

  void _joinRole(Party party, String role) {
    if (widget.studentId == party.creatorId) {
      _showMessage("You are already President");
      return;
    }
    setState(() {
      switch (role) {
        case "Vice President":
          party.vicePresidentId ??= widget.studentId;
          break;
        case "Secretary":
          party.secretaryId ??= widget.studentId;
          break;
        case "Joint Secretary":
          party.jointSecretaryId ??= widget.studentId;
          break;
      }
    });
    _showMessage("You joined '${party.name}' as $role");
  }

  void _deleteParty(Party party) {
    if (party.creatorId != widget.studentId) {
      _showMessage("Only the creator can delete this party");
      return;
    }
    setState(() {
      _parties.remove(party);
    });
    _showMessage("Party deleted successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Portal"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _partyController,
                  decoration: const InputDecoration(
                      labelText: "Party Name", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _createParty,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: const Text("Create Party"),
                ),
              ],
            ),
          ),
          Expanded(
            child: _parties.isEmpty
                ? const Center(child: Text("No parties yet"))
                : ListView.builder(
                itemCount: _parties.length,
                itemBuilder: (context, index) {
                  final party = _parties[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ExpansionTile(
                      title: Text(party.name,
                          style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle:
                      Text("President Votes: ${party.presidentVotes}"),
                      children: [
                        ListTile(
                            title: Text("President: ${party.creatorId}")),
                        _roleTile(party, "Vice President",
                            party.vicePresidentId),
                        _roleTile(party, "Secretary", party.secretaryId),
                        _roleTile(party, "Joint Secretary",
                            party.jointSecretaryId),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () => _votePresident(party),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple),
                                child: const Text("Vote President")),
                            ElevatedButton(
                                onPressed: () =>
                                    _voteRole(party, "Vice President"),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text("Vote VP")),
                            if (party.creatorId == widget.studentId)
                              ElevatedButton.icon(
                                  onPressed: () => _deleteParty(party),
                                  icon: const Icon(Icons.delete),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  label: const Text("Delete")),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
          if (_parties.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ResultsPage(parties: _parties)));
                },
                child: const Text("View Results"),
              ),
            ),
        ],
      ),
    );
  }

  Widget _roleTile(Party party, String role, String? assignedId) {
    return ListTile(
      title: Text("$role: ${assignedId ?? "Not Assigned"}"),
      trailing: assignedId == null
          ? ElevatedButton(
        onPressed: () => _joinRole(party, role),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
        child: const Text("Join"),
      )
          : null,
    );
  }
}
