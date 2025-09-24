import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DayUpdatesPage extends StatefulWidget {
  const DayUpdatesPage({super.key});

  @override
  State<DayUpdatesPage> createState() => _DayUpdatesPageState();
}

class _DayUpdatesPageState extends State<DayUpdatesPage> {
  List<Map<String, dynamic>> updates = [];
  bool loading = true;
  final String apiKey = '85b509b8e1454690b75301c308df7da2';

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
    setState(() {
      loading = true;
    });

    await Hive.initFlutter();
    var box = await Hive.openBox('techNews');

    try {
      final response = await http.get(Uri.parse(
          'https://newsapi.org/v2/top-headlines?category=technology&apiKey=$apiKey'));

      debugPrint("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Map<String, dynamic>> fetched = [];

        if (data['articles'] != null) {
          for (var article in data['articles']) {
            fetched.add({
              "title": article['title'] ?? "No title",
              "description": article['description'] ?? "",
              "image": article['urlToImage'],
              "time": article['publishedAt'] ?? DateTime.now().toIso8601String(),
              "url": article['url'],
            });
          }
        }

        // Remove news older than 3 days
        final now = DateTime.now();
        for (var key in box.keys) {
          final item = box.get(key);
          final published = DateTime.tryParse(item['time'] ?? "") ?? now;
          if (now.difference(published).inDays > 3) {
            box.delete(key);
          }
        }

        // Store new news
        for (var item in fetched) {
          box.put(item['time'], item);
        }
      } else {
        debugPrint("Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching news: $e");
    }

    // Load stored news
    setState(() {
      updates = box.values.cast<Map<String, dynamic>>().toList()
        ..sort((a, b) => b['time'].compareTo(a['time']));
      loading = false;
    });
  }

  String formatDate(String dateTime) {
    final dt = DateTime.tryParse(dateTime) ?? DateTime.now();
    return DateFormat('MMM dd, yyyy – hh:mm a').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Day-to-Day Tech Updates"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadNews,
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : updates.isEmpty
          ? const Center(child: Text("No updates available"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: updates.length,
        itemBuilder: (context, index) {
          final update = updates[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () async {
                if (update['url'] != null) {
                  final uri = Uri.parse(update['url']);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    update['image'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        update['image']!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        : Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      update['title'] ?? "No title",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      update['description'] ?? "",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatDate(update['time'] ?? ""),
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black38),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
