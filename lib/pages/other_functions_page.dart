import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';

class FunctionItem {
  final String userName;
  final String collegeName;
  final String content;
  final String contactNumber;
  final Uint8List? imageBytes;

  FunctionItem({
    required this.userName,
    required this.collegeName,
    required this.content,
    required this.contactNumber,
    this.imageBytes,
  });
}

class OtherFunctionsPage extends StatefulWidget {
  const OtherFunctionsPage({super.key});

  @override
  _OtherFunctionsPageState createState() => _OtherFunctionsPageState();
}

class _OtherFunctionsPageState extends State<OtherFunctionsPage> {
  final List<FunctionItem> functions = [];

  void _addNewFunction(String userName, String collegeName, String content, String contactNumber, Uint8List? imageBytes) {
    setState(() {
      functions.add(FunctionItem(
        userName: userName,
        collegeName: collegeName,
        content: content,
        contactNumber: contactNumber,
        imageBytes: imageBytes,
      ));
    });
  }

  Future<void> _launchApplyUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch application link")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Functions"),
        backgroundColor: Colors.deepPurple,
      ),
      body: functions.isEmpty
          ? const Center(child: Text("No functions yet. Tap + to create one!"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: functions.length,
        itemBuilder: (context, index) {
          final function = functions[index];
          return _buildFunctionCard(context, function);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewFunctionDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildFunctionCard(BuildContext context, FunctionItem function) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              function.collegeName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(function.content),
            if (function.imageBytes != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    function.imageBytes!,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onPressed: () {
                    final shareText =
                        "${function.content}\n\nCheck this out: https://example.com/functions/${function.collegeName.replaceAll(' ', '_')}";
                    Share.share(shareText);
                  },
                ),
                _buildActionButton(
                  icon: Icons.contact_phone_outlined,
                  label: 'Contact',
                  onPressed: () {
                    _showContactDialog(context, function);
                  },
                ),
                _buildActionButton(
                  icon: Icons.send_outlined,
                  label: 'Apply',
                  onPressed: () {
                    final applyUrl =
                        "https://example.com/apply/${function.collegeName.replaceAll(' ', '_')}";
                    _launchApplyUrl(applyUrl);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.deepPurple),
      label: Text(label, style: const TextStyle(color: Colors.deepPurple)),
    );
  }

  void _showContactDialog(BuildContext context, FunctionItem function) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contact Info"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 20),
                const SizedBox(width: 8),
                Text("User: ${function.userName}"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                Text("Phone: ${function.contactNumber}"),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showNewFunctionDialog(BuildContext context) {
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController collegeNameController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController contactNumberController = TextEditingController();
    Uint8List? selectedImageBytes;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create a New Function"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          final bytes = await image.readAsBytes();
                          setState(() {
                            selectedImageBytes = bytes;
                          });
                        }
                      },
                      child: selectedImageBytes == null
                          ? Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Text("Upload an image"),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Image.memory(
                          selectedImageBytes!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: userNameController,
                      decoration: const InputDecoration(hintText: "Enter your name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: collegeNameController,
                      decoration: const InputDecoration(hintText: "Enter college name"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contactNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: "Enter contact number"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(hintText: "Enter category of function"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    userNameController.dispose();
                    collegeNameController.dispose();
                    categoryController.dispose();
                    contactNumberController.dispose();
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final userName = userNameController.text.trim();
                    final collegeName = collegeNameController.text.trim();
                    final category = categoryController.text.trim();
                    final contactNumber = contactNumberController.text.trim();

                    if (selectedImageBytes == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please upload an image first!")),
                      );
                      return;
                    }

                    if (userName.isEmpty || collegeName.isEmpty || category.isEmpty || contactNumber.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill out all fields!")),
                      );
                      return;
                    }

                    _addNewFunction(userName, collegeName, category, contactNumber, selectedImageBytes);

                    userNameController.dispose();
                    collegeNameController.dispose();
                    categoryController.dispose();
                    contactNumberController.dispose();

                    Navigator.pop(context);
                  },
                  child: const Text("Post"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
