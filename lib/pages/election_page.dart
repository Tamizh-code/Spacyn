import 'package:flutter/material.dart';
import 'results_page.dart';


class Party {
  String name;
  int votes;
  String creatorId;

  Party({required this.name, required this.creatorId, this.votes = 0});
}

class ElectionPage extends StatefulWidget {
  @override
  _ElectionPageState createState() => _ElectionPageState();
}

class _ElectionPageState extends State<ElectionPage> {
  final List<Party> _parties = [];
  final Map<String, bool> _studentVotes = {}; // studentId → hasVoted
  final TextEditingController _partyController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  void _createParty() {
    String id = _idController.text.trim();
    String name = _partyController.text.trim();

    if (id.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter both ID and Party name")),
      );
      return;
    }

    // Check if student already created a party
    if (_parties.any((p) => p.creatorId == id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only create one party")),
      );
      return;
    }

    setState(() {
      _parties.add(Party(name: name, creatorId: id));
      _partyController.clear();
      _idController.clear();
    });
  }

  void _vote(Party party, String studentId) {
    if (_studentVotes[studentId] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have already voted")),
      );
      return;
    }

    setState(() {
      party.votes += 1;
      _studentVotes[studentId] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Election Portal")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: "Your Student ID",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _partyController,
                  decoration: InputDecoration(
                    labelText: "Party Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _createParty,
                  child: Text("Create Party"),
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
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(party.name),
                    subtitle: Text("Votes: ${party.votes}"),
                    trailing: IconButton(
                      icon: Icon(Icons.how_to_vote, color: Colors.blue),
                      onPressed: () {
                        _vote(party, _idController.text.trim());
                      },
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
              child: Text("View Results"),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
