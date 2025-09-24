import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'election_page.dart';

// ------------------- Card Model -------------------
class MoreCard {
  String name;
  IconData icon;
  String link; // web URL or internal page name
  bool isWeb; // true if it's a web link
  Color startColor;
  Color endColor;
  bool createdByUser; // track user-created cards
  bool isFavorite; // favorite feature

  MoreCard({
    required this.name,
    required this.icon,
    required this.link,
    this.isWeb = true,
    this.startColor = Colors.deepPurple,
    this.endColor = Colors.purpleAccent,
    this.createdByUser = false,
    this.isFavorite = false,
  });
}

class MorePage extends StatefulWidget {
  final String studentId;

  const MorePage({super.key, required this.studentId});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  List<MoreCard> cards = [
    MoreCard(
      name: "Election Portal",
      icon: Icons.how_to_vote,
      link: "ElectionPage",
      isWeb: false,
      createdByUser: false,
    ),
    MoreCard(
      name: "LMS Portal",
      icon: Icons.school,
      link: "https://lms.yourschool.edu",
      createdByUser: false,
    ),
    MoreCard(
      name: "Events",
      icon: Icons.event,
      link: "https://collegeevents.com",
      createdByUser: false,
    ),
  ];

  // ------------------- Open Card -------------------
  void openCard(MoreCard card) async {
    if (card.isWeb) {
      Uri url = Uri.parse(card.link);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Cannot open ${card.link}")));
      }
    } else {
      switch (card.link) {
        case "ElectionPage":
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ElectionPage(studentId: widget.studentId)),
          );
          break;
      }
    }
  }

  // ------------------- Pick Color -------------------
  Future<Color?> pickColor(Color currentColor) async {
    Color pickedColor = currentColor;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) => pickedColor = color,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context), child: const Text("Select"))
        ],
      ),
    );

    return pickedColor;
  }

  // ------------------- Add New Card -------------------
  void addNewCard() {
    final _nameController = TextEditingController();
    final _linkController = TextEditingController();
    IconData selectedIcon = Icons.star;
    bool isWeb = true;
    Color startColor = Colors.deepPurple;
    Color endColor = Colors.purpleAccent;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text("Add New Card"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Card Name")),
                const SizedBox(height: 10),
                TextField(
                    controller: _linkController,
                    decoration: const InputDecoration(labelText: "Link")),
                const SizedBox(height: 10),
                DropdownButton<IconData>(
                  value: selectedIcon,
                  items: [
                    DropdownMenuItem(
                        value: Icons.school,
                        child: Row(children: [Icon(Icons.school), const Text(" School")])),
                    DropdownMenuItem(
                        value: Icons.how_to_vote,
                        child: Row(children: [Icon(Icons.how_to_vote), const Text(" Vote")])),
                    DropdownMenuItem(
                        value: Icons.event,
                        child: Row(children: [Icon(Icons.event), const Text(" Event")])),
                    DropdownMenuItem(
                        value: Icons.web,
                        child: Row(children: [Icon(Icons.web), const Text(" Web")])),
                    DropdownMenuItem(
                        value: Icons.star,
                        child: Row(children: [Icon(Icons.star), const Text(" Star")])),
                    DropdownMenuItem(
                        value: Icons.camera_alt,
                        child: Row(children: [Icon(Icons.camera_alt), const Text(" Camera")])),
                    DropdownMenuItem(
                        value: Icons.alarm,
                        child: Row(children: [Icon(Icons.alarm), const Text(" Alarm")])),
                  ],
                  onChanged: (value) {
                    if (value != null) setStateDialog(() => selectedIcon = value);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text("Is Web Link?"),
                    Switch(value: isWeb, onChanged: (v) => setStateDialog(() => isWeb = v)),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () async {
                      Color? c = await pickColor(startColor);
                      if (c != null) setStateDialog(() => startColor = c);
                    },
                    child: const Text("Pick Start Color")),
                ElevatedButton(
                    onPressed: () async {
                      Color? c = await pickColor(endColor);
                      if (c != null) setStateDialog(() => endColor = c);
                    },
                    child: const Text("Pick End Color")),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty || _linkController.text.isEmpty) return;
                setState(() {
                  cards.add(MoreCard(
                    name: _nameController.text,
                    icon: selectedIcon,
                    link: _linkController.text,
                    isWeb: isWeb,
                    startColor: startColor,
                    endColor: endColor,
                    createdByUser: true,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------- Build -------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("More Page"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85, // slightly smaller card
          ),
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final card = cards[index];
            return GestureDetector(
              onTap: () => openCard(card),
              onLongPress: () {
                // Only allow deletion if created by user
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(card.name),
                    content: card.createdByUser
                        ? const Text("Do you want to delete or favorite this card?")
                        : const Text("You cannot delete this default card."),
                    actions: card.createdByUser
                        ? [
                      TextButton(
                          onPressed: () {
                            setState(() => card.isFavorite = !card.isFavorite);
                            Navigator.pop(ctx);
                          },
                          child: Text(card.isFavorite ? "Unfavorite" : "Favorite")),
                      ElevatedButton(
                          onPressed: () {
                            setState(() => cards.removeAt(index));
                            Navigator.pop(ctx);
                          },
                          child: const Text("Delete")),
                    ]
                        : [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("OK")),
                    ],
                  ),
                );
              },
              child: Tooltip(
                message: card.isFavorite ? "★ Favorite" : card.name,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [card.startColor, card.endColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: card.endColor.withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(2, 2)),
                    ],
                  ),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(card.icon, size: 40, color: Colors.white),
                            const SizedBox(height: 8),
                            Text(
                              card.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        if (card.isFavorite)
                          const Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(Icons.star, color: Colors.yellow, size: 20),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewCard,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
