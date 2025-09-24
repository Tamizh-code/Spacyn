// updates_page_with_attachments.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

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
      "filePath": null,
      "fileName": null,
      "fileType": null,
    },
    {
      "title": "Class Allocation Updated",
      "subtitle": "Admin Office",
      "details": "New class allocations for 3rd year students are available.",
      "category": "Class",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "pinned": false,
      "seen": true,
      "filePath": null,
      "fileName": null,
      "fileType": null,
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
      final matchesSearch =
      update["title"].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesCategory =
          selectedCategory == "All" || update["category"] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<Map<String, String>?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'gif', 'doc', 'docx'],
    );
    if (result == null) return null;

    final filePath = result.files.single.path;
    final fileName = result.files.single.name;
    final ext = fileName.contains('.') ? fileName.split('.').last : '';

    if (filePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("File picked but path unavailable on this platform.")));
      return null;
    }

    return {
      "filePath": filePath,
      "fileName": fileName,
      "fileType": ext.toLowerCase(),
    };
  }

  void _addOrEditUpdate({Map<String, dynamic>? existing, int? originalIndex}) {
    final titleController =
    TextEditingController(text: existing != null ? existing["title"] : "");
    final subtitleController = TextEditingController(
        text: existing != null ? existing["subtitle"] : "");
    final detailsController = TextEditingController(
        text: existing != null ? existing["details"] : "");
    String category = existing != null ? existing["category"] : "Exam";
    bool pinned = existing?["pinned"] ?? false;

    String? dialogFilePath = existing?["filePath"];
    String? dialogFileName = existing?["fileName"];
    String? dialogFileType = existing?["fileType"];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(existing == null ? "Add Update" : "Edit Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: subtitleController,
                    decoration: const InputDecoration(labelText: "Subtitle"),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: detailsController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Details"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: category,
                    isExpanded: true,
                    items: [
                      "Exam",
                      "Class",
                      "Staff",
                      "Announcement",
                      "Circular"
                    ]
                        .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) =>
                        setStateDialog(() => category = value!),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: pinned,
                        onChanged: (val) => setStateDialog(() => pinned = val!),
                      ),
                      const Text("Pin this update 📌")
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Attachment (optional):"),
                        const SizedBox(height: 6),
                        if (dialogFileName != null)
                          Row(
                            children: [
                              const Icon(Icons.attach_file),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: Text(dialogFileName ?? "",
                                      overflow: TextOverflow.ellipsis)),
                              TextButton(
                                onPressed: () {
                                  setStateDialog(() {
                                    dialogFileName = null;
                                    dialogFilePath = null;
                                    dialogFileType = null;
                                  });
                                },
                                child: const Text("Remove"),
                              )
                            ],
                          )
                        else
                          TextButton.icon(
                            onPressed: () async {
                              final picked = await _pickFile();
                              if (picked != null) {
                                setStateDialog(() {
                                  dialogFilePath = picked["filePath"];
                                  dialogFileName = picked["fileName"];
                                  dialogFileType = picked["fileType"];
                                });
                              }
                            },
                            icon: const Icon(Icons.upload_file),
                            label: const Text("Choose file"),
                          ),
                      ],
                    ),
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
                    "seen": existing != null ? existing["seen"] : false,
                    "filePath": dialogFilePath,
                    "fileName": dialogFileName,
                    "fileType": dialogFileType,
                  };
                  setState(() {
                    if (existing == null) {
                      updates.add(newUpdate);
                    } else {
                      updates[originalIndex!] = newUpdate;
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteUpdate(int originalIndex) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete update?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete")),
        ],
      ),
    ) ??
        false;
    if (!confirmed) return;

    setState(() {
      updates.removeAt(originalIndex);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Update deleted.")));
  }

  void _markAsRead(int originalIndex) {
    setState(() {
      updates[originalIndex]["seen"] = true;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Marked as read.")));
  }

  void _markAllAsRead() {
    setState(() {
      for (var u in updates) {
        u["seen"] = true;
      }
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("All marked as read.")));
  }

  Future<void> _openOrAttachFile(Map<String, dynamic> update) async {
    if (update["filePath"] == null) {
      final picked = await _pickFile();
      if (picked != null) {
        setState(() {
          update["filePath"] = picked["filePath"];
          update["fileName"] = picked["fileName"];
          update["fileType"] = picked["fileType"];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File '${picked["fileName"]}' attached.")),
        );
      }
    } else {
      final result = await OpenFile.open(update["filePath"]);
      if (result.type != ResultType.done) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Could not open ${update["fileName"]}: ${result.message}")),
        );
      }
    }
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
            ),
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            tooltip: "Mark all read",
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search updates...",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: [
                "All",
                "Exam",
                "Class",
                "Staff",
                "Announcement",
                "Circular"
              ]
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredUpdates.isEmpty
                ? const Center(child: Text("No updates found."))
                : ListView.builder(
              itemCount: filteredUpdates.length,
              itemBuilder: (context, filteredIndex) {
                final update = filteredUpdates[filteredIndex];
                final originalIndex = updates.indexOf(update);

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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6),
                        child: GestureDetector(
                          onTap: () => _openOrAttachFile(update),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.deepPurple, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.attach_file,
                                    color: Colors.deepPurple),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    update["fileName"] ??
                                        "Tap to add/open attachment",
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!widget.isAdmin && !update["seen"])
                            TextButton.icon(
                              onPressed: () =>
                                  _markAsRead(originalIndex),
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                              label: const Text("Mark as Read"),
                            ),
                          if (widget.isAdmin) ...[
                            TextButton.icon(
                              onPressed: () => _addOrEditUpdate(
                                  existing: update,
                                  originalIndex: originalIndex),
                              icon: const Icon(Icons.edit,
                                  color: Colors.orange),
                              label: const Text("Edit"),
                            ),
                            TextButton.icon(
                              onPressed: () => _deleteUpdate(originalIndex),
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
