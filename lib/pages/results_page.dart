import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'election_page.dart'; // for Party class

class ResultsPage extends StatelessWidget {
  final List<Party> parties;

  const ResultsPage({super.key, required this.parties});

  @override
  Widget build(BuildContext context) {
    // Sort parties by votes (descending)
    final sortedParties = [...parties]..sort((a, b) => b.votes.compareTo(a.votes));
    final totalVotes = parties.fold(0, (sum, p) => sum + p.votes);
    final winner = sortedParties.isNotEmpty ? sortedParties.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Election Results"),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
              // 🔥 Future idea: Generate a PDF report
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Report download not implemented yet.")),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🏆 Winner Section
            if (winner != null)
              Card(
                color: Colors.yellow.shade100,
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                child: ListTile(
                  leading: const Icon(Icons.emoji_events, color: Colors.orange, size: 40),
                  title: Text(
                    "🏆 Winner: ${winner.name}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Votes: ${winner.votes}"),
                ),
              ),

            const Text(
              "Vote Share Distribution",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 📊 Pie Chart
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: parties.map((party) {
                    final percentage = totalVotes == 0
                        ? 0
                        : (party.votes / totalVotes) * 100;
                    return PieChartSectionData(
                      title: "${party.name}\n${percentage.toStringAsFixed(1)}%",
                      value: party.votes.toDouble(),
                      radius: 90,
                      color: Colors.primaries[
                      parties.indexOf(party) % Colors.primaries.length],
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Party Ranking",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            // 📋 Ranking List
            Expanded(
              child: ListView.builder(
                itemCount: sortedParties.length,
                itemBuilder: (context, index) {
                  final party = sortedParties[index];
                  final percentage = totalVotes == 0
                      ? 0
                      : (party.votes / totalVotes) * 100;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[
                        index % Colors.primaries.length],
                        child: Text("${index + 1}"),
                      ),
                      title: Text(
                        party.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "Votes: ${party.votes} (${percentage.toStringAsFixed(1)}%)"),
                      trailing: index == 0
                          ? const Icon(Icons.emoji_events, color: Colors.orange)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
