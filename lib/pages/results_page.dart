import 'package:flutter/material.dart';
import 'election_page.dart';

class ResultsPage extends StatelessWidget {
  final List<Party> parties;
  const ResultsPage({super.key, this.parties = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Results"),
        backgroundColor: Colors.green,
      ),
      body: parties.isEmpty
          ? const Center(child: Text("No results yet"))
          : ListView.builder(
        itemCount: parties.length,
        itemBuilder: (context, index) {
          final party = parties[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(party.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("President: ${party.creatorId} "
                      "(${party.presidentVotes} votes)"),
                  Text("Vice President: ${party.vicePresidentId ?? "-"} "
                      "(${party.viceVotes} votes)"),
                  Text("Secretary: ${party.secretaryId ?? "-"} "
                      "(${party.secretaryVotes} votes)"),
                  Text("Joint Secretary: ${party.jointSecretaryId ?? "-"} "
                      "(${party.jointVotes} votes)"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
