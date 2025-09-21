import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({super.key, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  String name = "Harsath CSE";
  String phone = "+91 98765 43210";
  String location = "Chennai, India";
  String github = "https://github.com/username";
  String linkedIn = "https://www.linkedin.com/in/username";
  String twitter = "https://twitter.com/username";

  bool isDarkMode = false;
  File? profileImage;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _progressAnimation = Tween<double>(begin: 0, end: profileCompletion())
        .animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));
    _progressController.forward();
  }

  double profileCompletion() {
    int completed = 0;
    if (name.isNotEmpty) completed++;
    if (phone.isNotEmpty) completed++;
    if (location.isNotEmpty) completed++;
    if (github.isNotEmpty) completed++;
    if (linkedIn.isNotEmpty) completed++;
    if (twitter.isNotEmpty) completed++;
    return completed / 6;
  }

  void _editField(String field, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              _animateProgress();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _animateProgress() {
    _progressController.reset();
    _progressAnimation = Tween<double>(begin: 0, end: profileCompletion())
        .animate(CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));
    _progressController.forward();
  }

  void _pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImage = File(picked.path);
      });
    }
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$label copied")));
  }

  Future<void> _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open link")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : const AssetImage("assets/images/profile.jpg") as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickProfileImage,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => _copyToClipboard(widget.userEmail, "Email"),
                child: Text(widget.userEmail, style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ),
              const SizedBox(height: 10),

              // Animated Profile Completion
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) => LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: Colors.grey.shade300,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () => _editField("Name", name, (val) => setState(() => name = val)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Edit Profile"),
              ),
              const SizedBox(height: 25),

              _buildInfoCard(Icons.email, "Email", widget.userEmail, false, true),
              _buildInfoCard(Icons.phone, "Phone", phone, true, true),
              _buildInfoCard(Icons.location_on, "Location", location, true, false),

              const SizedBox(height: 25),
              const Text("Social Links", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildSocialCard(Icons.code, "GitHub", github, () => _launchURL(github)),
              _buildSocialCard(Icons.business, "LinkedIn", linkedIn, () => _launchURL(linkedIn)),
              _buildSocialCard(Icons.alternate_email, "Twitter", twitter, () => _launchURL(twitter)),

              const SizedBox(height: 30),

              // Settings Section
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
                        ListTile(
                          leading: const Icon(Icons.lock, color: Colors.deepPurple),
                          title: const Text("Privacy"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Privacy settings")));
                          },
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                          title: const Text("Notifications"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Notification settings")));
                          },
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text("Logout", style: TextStyle(color: Colors.red)),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle, bool editable, bool copyable) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (copyable)
              IconButton(
                  icon: const Icon(Icons.copy, color: Colors.deepPurple),
                  onPressed: () => _copyToClipboard(subtitle, title)),
            if (editable)
              IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                  onPressed: () => _editField(title, subtitle, (newValue) {
                    setState(() {
                      if (title == "Phone") phone = newValue;
                      if (title == "Location") location = newValue;
                      _animateProgress();
                    });
                  })),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialCard(IconData icon, String title, String url, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(url),
        trailing: IconButton(icon: const Icon(Icons.launch, color: Colors.deepPurple), onPressed: onTap),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }
}
