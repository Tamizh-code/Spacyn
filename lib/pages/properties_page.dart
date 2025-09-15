import 'package:flutter/material.dart';

class PropertiesPage extends StatefulWidget {
  const PropertiesPage({super.key});

  @override
  State<PropertiesPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<PropertiesPage> {
  DateTime _selectedDate = DateTime.now();
  Map<String, List<Map<String, dynamic>>> tasks = {};

  @override
  Widget build(BuildContext context) {
    final dateKey = _selectedDate.toIso8601String().split('T')[0];
    final dayTasks = tasks[dateKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Properties"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔹 Date Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Selected Date: $dateKey",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.deepPurple,
                              onPrimary: Colors.white,
                              onSurface: Colors.deepPurple,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: const Text("Pick Date"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔹 Add Task Button
            ElevatedButton.icon(
              onPressed: () => _showAddTaskDialog(context),
              icon: const Icon(Icons.add_task),
              label: const Text("Add Task"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white),
            ),
            const SizedBox(height: 20),

            // 🔹 Task List
            dayTasks.isEmpty
                ? const Text(
              "No tasks for this date.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayTasks.length,
              itemBuilder: (context, index) {
                final task = dayTasks[index];
                return Card(
                  elevation: 3,
                  child: ListTile(
                    leading: IconButton(
                      icon: Icon(
                        task["completed"]
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: task["completed"]
                            ? Colors.green
                            : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          task["completed"] = !task["completed"];
                        });
                      },
                    ),
                    title: Text(
                      task["title"],
                      style: TextStyle(
                        decoration: task["completed"]
                            ? TextDecoration.lineThrough
                            : null,
                        color: task["completed"]
                            ? Colors.grey
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(task["description"]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditTaskDialog(context, index, task);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              dayTasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Add Task Dialog
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Task Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: "Task Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              final dateKey = _selectedDate.toIso8601String().split('T')[0];
              setState(() {
                tasks[dateKey] ??= [];
                tasks[dateKey]!.add({
                  "title": titleController.text,
                  "description": descController.text,
                  "completed": false,
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // 🔹 Edit Task Dialog
  void _showEditTaskDialog(
      BuildContext context, int index, Map<String, dynamic> task) {
    final titleController = TextEditingController(text: task["title"]);
    final descController = TextEditingController(text: task["description"]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Task Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: "Task Description"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              setState(() {
                task["title"] = titleController.text;
                task["description"] = descController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
