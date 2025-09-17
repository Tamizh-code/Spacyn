import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'election_page.dart';

class ResultsPage extends StatelessWidget {
  final List<Party> parties;
  const ResultsPage({super.key, required this.parties});

  @override
  Widget build(BuildContext context) {
    final series = [
      charts.Series<Party, String>(
        id: 'Votes',
        domainFn: (Party party, _) => party.name,
        measureFn: (Party party, _) => party.votes,
        data: parties,
        labelAccessorFn: (Party party, _) => '${party.votes}',
      )
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Election Results")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: charts.BarChart(series, animate: true)),
            const SizedBox(height: 20),
            Expanded(child: charts.PieChart(series, animate: true)),
          ],
        ),
      ),
    );
  }
}
