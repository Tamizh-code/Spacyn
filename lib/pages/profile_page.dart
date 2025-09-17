import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/login_page.dart'; // your real login page

class ProfilePage extends StatefulWidget {
  final String userEmail;
  final bool isDarkMode;
  final Function(bool) onToggleTheme;

  const ProfilePage({
    super.key,
    required this.userEmail,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Harsath CSE";
  String phone = "+91 98765 43210";
  String location = "Chennai, India";
  DateTime joinDate = DateTime(2023, 7, 1); // Example join date

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() => _profileImage = File(pickedImage.path));
    }
  }

  // Pick image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() => _profileImage = File(pickedImage.path));
    }
  }

  // Edit info field
  void _editField(String field, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter new $field"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Show dialog to choose camera/gallery
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Pick from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile picture
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!) as ImageProvider
                        : const AssetImage("assets/images/profile.jpg"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.deepPurple,
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Name
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

            // Email
            Text(widget.userEmail, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 5),

            // Date of joining
            Text("Joined on: ${joinDate.day}-${joinDate.month}-${joinDate.year}",
                style: const TextStyle(fontSize: 14, color: Colors.grey)),

            const SizedBox(height: 20),

            // Edit Name button
            ElevatedButton.icon(
              onPressed: () => _editField("Name", name, (newValue) => setState(() => name = newValue)),
              icon: const Icon(Icons.edit, size: 18),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              ),
            ),

            const SizedBox(height: 25),

            // Info Cards
            _buildInfoCard(Icons.email, "Email", widget.userEmail, false),
            _buildInfoCard(Icons.phone, "Phone", phone, true),
            _buildInfoCard(Icons.location_on, "Location", location, true),

            const SizedBox(height: 30),

            // Settings
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text("Dark Mode"),
                        secondary: const Icon(Icons.dark_mode, color: Colors.deepPurple),
                        value: widget.isDarkMode,
                        onChanged: widget.onToggleTheme,
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.lock, color: Colors.deepPurple),
                        title: const Text("Privacy"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text("Privacy settings"))),
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text("Logout", style: TextStyle(color: Colors.red)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle, bool editable) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: editable
            ? IconButton(
          icon: const Icon(Icons.edit, color: Colors.deepPurple),
          onPressed: () => _editField(title, subtitle, (newValue) {
            setState(() {
              if (title == "Phone") phone = newValue;
              if (title == "Location") location = newValue;
            });
          }),
        )
            : null,
      ),
    );
  }
}
