import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdatesPage extends StatefulWidget {
  final bool isAdmin; // true = staff/admin, false = student

  const UpdatesPage({super.key, this.isAdmin = false});

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  List<Map<String, dynamic>> updates = [
    {
      "title": "Exam Timetable Released",
      "subtitle": "CSE Dept",
      "details": "The end-semester exam timetable for 2nd year CSE is out.",
      "category": "Exam",
      "timestamp": DateTime.now().subtract(const Duration(hours: 3)),
      "pinned": true,
      "seen": false,
      "file": null
    },
    {
      "title": "Class Allocation Updated",
      "subtitle": "Admin Office",
      "details": "New class allocations for 3rd year students are available.",
      "category": "Class",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "pinned": false,
      "seen": true,
      "file": null
    },
  ];

  String searchQuery = "";
  String selectedCategory = "All";

  List<Map<String, dynamic>> get filteredUpdates {
    final sorted = [...updates];
    sorted.sort((a, b) {
      if (a["pinned"] == true && b["pinned"] == false) return -1;
      if (a["pinned"] == false && b["pinned"] == true) return 1;
      return b["timestamp"].compareTo(a["timestamp"]);
    });

    return sorted.where((update) {
      final matchesSearch = update["title"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == "All" || update["category"] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _addOrEditUpdate({Map<String, dynamic>? existing, int? index}) {
    final titleController =
    TextEditingController(text: existing != null ? existing["title"] : "");
    final subtitleController =
    TextEditingController(text: existing != null ? existing["subtitle"] : "");
    final detailsController =
    TextEditingController(text: existing != null ? existing["details"] : "");
    String category = existing != null ? existing["category"] : "Exam";
    bool pinned = existing?["pinned"] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? "Add Update" : "Edit Update"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),




                TextField(
                  controller: subtitleController,
                  decoration: const InputDecoration(labelText: "Subtitle"),
                ),
                TextField(
                  controller: detailsController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Details"),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: category,
                  items: ["Exam", "Class", "Staff", "Announcement", "Circular"]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) => setState(() => category = value!),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: pinned,
                      onChanged: (val) => setState(() => pinned = val!),
                    ),
                    const Text("Pin this update 📌")
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                final newUpdate = {
                  "title": titleController.text,
                  "subtitle": subtitleController.text,
                  "details": detailsController.text,
                  "category": category,
                  "timestamp": DateTime.now(),
                  "pinned": pinned,
                  "seen": false,
                  "file": null, // Placeholder for file upload
                };
                setState(() {
                  if (existing == null) {
                    updates.add(newUpdate);
                  } else {
                    updates[index!] = newUpdate;
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteUpdate(int index) {
    setState(() {
      updates.removeAt(index);
    });
  }

  void _markAsRead(int index) {
    setState(() {
      updates[index]["seen"] = true;
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat('MMM d, yyyy • hh:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("Department Updates"),
        backgroundColor: Colors.deepPurple,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          if (widget.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addOrEditUpdate(),
            )
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search updates...",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          // 📂 Category filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: ["All", "Exam", "Class", "Staff", "Announcement", "Circular"]
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
          ),
          const SizedBox(height: 8),
          // 📢 Updates List
          Expanded(
            child: filteredUpdates.isEmpty
                ? const Center(
              child: Text("No updates found."),
            )
                : ListView.builder(
              itemCount: filteredUpdates.length,
              itemBuilder: (context, index) {
                final update = filteredUpdates[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: update["pinned"] ? 6 : 3,
                  child: ExpansionTile(
                    leading: Icon(
                      update["pinned"]
                          ? Icons.push_pin
                          : Icons.notifications,
                      color: update["pinned"]
                          ? Colors.red
                          : Colors.deepPurple,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            update["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple.shade800,
                            ),
                          ),
                        ),
                        if (update["seen"] == false && !widget.isAdmin)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "NEW",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                        "${update["subtitle"]} • ${_formatTime(update["timestamp"])}"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(update["details"]),
                      ),
                      if (update["file"] != null)
                        TextButton.icon(
                          onPressed: () {
                            // open file link (future storage integration)
                          },
                          icon: const Icon(Icons.attach_file),
                          label: const Text("View Attachment"),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!widget.isAdmin && !update["seen"])
                            TextButton.icon(
                              onPressed: () => _markAsRead(index),
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                              label: const Text("Mark as Read"),
                            ),
                          if (widget.isAdmin) ...[
                            TextButton.icon(
                              onPressed: () => _addOrEditUpdate(
                                  existing: update, index: index),
                              icon: const Icon(Icons.edit,
                                  color: Colors.orange),
                              label: const Text("Edit"),
                            ),
                            TextButton.icon(
                              onPressed: () => _deleteUpdate(index),
                              icon: const Icon(Icons.delete,
                                  color: Colors.red),
                              label: const Text("Delete"),
                            ),
                          ],
                          const SizedBox(width: 8),
                        ],
                      )
                    ],
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
