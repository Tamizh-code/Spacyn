import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// -------------------- Theme Colors --------------------
final Color primaryColor = Colors.deepPurple;
final Color accentColor = Colors.deepPurpleAccent;
final Color textDark = Colors.black87;
final Color textLight = Colors.white;

// -------------------- Student Profile Model --------------------
class StudentProfile {
  String email;
  String name;
  List<String> skills;
  String excellence;
  String bio;
  String department;
  String year;
  String github;
  String linkedin;
  String portfolio;
  String? profileImagePath;

  StudentProfile({
    required this.email,
    required this.name,
    required this.skills,
    required this.excellence,
    this.bio = "",
    this.department = "",
    this.year = "",
    this.github = "",
    this.linkedin = "",
    this.portfolio = "",
    this.profileImagePath,
  });
}

// -------------------- Stud Media Home Page --------------------
class StudMediaHomePage extends StatefulWidget {
  final String userEmail;

  const StudMediaHomePage({super.key, required this.userEmail});

  @override
  State<StudMediaHomePage> createState() => _StudMediaHomePageState();
}

class _StudMediaHomePageState extends State<StudMediaHomePage> {
  List<StudentProfile> profiles = [
    StudentProfile(
      email: "harsath@example.com",
      name: "Harsath Mohamed",
      skills: ["Flutter", "Python", "UI/UX Design"],
      excellence: "Won 1st prize in Hackathon 2025",
      bio: "Passionate Flutter developer",
      department: "CSE",
      year: "2nd Year",
      github: "https://github.com/alice",
      linkedin: "https://linkedin.com/in/alice",
    ),
    StudentProfile(
      email: "mani@example.com",
      name: "Mani Conqueror",
      skills: ["Java", "C++", "Machine Learning"],
      excellence: "Published research in AI Journal",
      bio: "ML enthusiast and researcher",
      department: "AI&DS",
      year: "3rd Year",
      github: "https://github.com/bob",
      linkedin: "https://linkedin.com/in/bob",
    ),
  ];

  String searchQuery = "";

  List<StudentProfile> get filteredProfiles {
    if (searchQuery.isEmpty) return profiles;
    return profiles
        .where((p) =>
        p.skills.any((skill) => skill.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();
  }

  StudentProfile? getCurrentUserProfile() {
    try {
      return profiles.firstWhere((p) => p.email == widget.userEmail);
    } catch (e) {
      return null;
    }
  }

  void _addNewProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          profile: StudentProfile(
            email: widget.userEmail,
            name: "",
            skills: [],
            excellence: "",
          ),
          onSave: (newProfile) {
            setState(() {
              profiles.add(newProfile);
            });
          },
        ),
      ),
    );
  }

  void _openStudentProfile(StudentProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewStudentProfilePage(
          profile: profile,
          currentUser: getCurrentUserProfile(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProfile = getCurrentUserProfile();

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        title: const Text("Stud Pedia"),
        backgroundColor: primaryColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // -------------------- Search Bar --------------------
            TextField(
              decoration: InputDecoration(
                hintText: "Search by skills...",
                prefixIcon: Icon(Icons.search, color: primaryColor),
                filled: true,
                fillColor: Colors.deepPurple.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 12),
            // -------------------- Create Profile Button --------------------
            if (currentUserProfile == null)
              ElevatedButton.icon(
                onPressed: _addNewProfile,
                icon: const Icon(Icons.add),
                label: const Text("Create Your Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textLight,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
              ),
            const SizedBox(height: 12),
            // -------------------- Profiles List --------------------
            Expanded(
              child: ListView.builder(
                itemCount: filteredProfiles.length,
                itemBuilder: (context, index) {
                  final profile = filteredProfiles[index];
                  final isCurrentUser = profile.email == widget.userEmail;

                  return StudentProfileCard(
                    profile: profile,
                    isCurrentUser: isCurrentUser,
                    onEdit: isCurrentUser
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            profile: profile,
                            onSave: (updatedProfile) {
                              setState(() {
                                profiles[index] = updatedProfile;
                              });
                            },
                          ),
                        ),
                      );
                    }
                        : null,
                    onDelete: isCurrentUser
                        ? () {
                      setState(() {
                        profiles.removeAt(index);
                      });
                    }
                        : null,
                    onShare: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Sharing ${profile.name}...")));
                    },
                    onRecruit: () {
                      _openStudentProfile(profile);
                    },
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

// -------------------- Profile Card --------------------
class StudentProfileCard extends StatelessWidget {
  final StudentProfile profile;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onShare;
  final VoidCallback? onRecruit;
  final bool isCurrentUser;

  const StudentProfileCard({
    super.key,
    required this.profile,
    this.onEdit,
    this.onDelete,
    this.onShare,
    this.onRecruit,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: primaryColor.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: profile.profileImagePath != null
                    ? FileImage(File(profile.profileImagePath!))
                    : null,
                backgroundColor: primaryColor.withOpacity(0.8),
                child: profile.profileImagePath == null
                    ? Text(
                  profile.name.isNotEmpty ? profile.name[0] : "?",
                  style: TextStyle(fontSize: 24, color: textLight),
                )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  profile.name.isNotEmpty ? profile.name : "No Name",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (profile.bio.isNotEmpty)
            Text(profile.bio,
                style: TextStyle(fontSize: 14, color: textDark)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: profile.skills
                .map((skill) => Chip(
              label: Text(skill),
              backgroundColor: accentColor.withOpacity(0.2),
              labelStyle: TextStyle(color: primaryColor),
            ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  profile.excellence.isNotEmpty
                      ? profile.excellence
                      : "No achievements",
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: primaryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!isCurrentUser)
            ElevatedButton.icon(
              onPressed: onRecruit,
              icon: const Icon(Icons.how_to_reg),
              label: const Text("View Profile"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: textLight,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          if (isCurrentUser)
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: primaryColor),
                onSelected: (value) {
                  switch (value) {
                    case 'Edit':
                      if (onEdit != null) onEdit!();
                      break;
                    case 'Delete':
                      if (onDelete != null) onDelete!();
                      break;
                    case 'Share':
                      if (onShare != null) onShare!();
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'Share', child: Text('Share')),
                ],
              ),
            ),
        ]),
      ),
    );
  }
}

// -------------------- Edit Profile Page --------------------
class EditProfilePage extends StatefulWidget {
  final StudentProfile profile;
  final Function(StudentProfile) onSave;

  const EditProfilePage({super.key, required this.profile, required this.onSave});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController skillsController;
  late TextEditingController excellenceController;
  late TextEditingController bioController;
  late TextEditingController departmentController;
  late TextEditingController yearController;
  late TextEditingController githubController;
  late TextEditingController linkedinController;
  late TextEditingController portfolioController;
  String? profileImagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    skillsController = TextEditingController(text: widget.profile.skills.join(", "));
    excellenceController = TextEditingController(text: widget.profile.excellence);
    bioController = TextEditingController(text: widget.profile.bio);
    departmentController = TextEditingController(text: widget.profile.department);
    yearController = TextEditingController(text: widget.profile.year);
    githubController = TextEditingController(text: widget.profile.github);
    linkedinController = TextEditingController(text: widget.profile.linkedin);
    portfolioController = TextEditingController(text: widget.profile.portfolio);
    profileImagePath = widget.profile.profileImagePath;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
              profileImagePath != null ? FileImage(File(profileImagePath!)) : null,
              backgroundColor: primaryColor.withOpacity(0.7),
              child: profileImagePath == null
                  ? Icon(Icons.camera_alt, color: textLight, size: 32)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField(nameController, "Name"),
          const SizedBox(height: 12),
          _buildTextField(skillsController, "Skills (comma separated)"),
          const SizedBox(height: 12),
          _buildTextField(excellenceController, "Excellence / Achievements"),
          const SizedBox(height: 12),
          _buildTextField(bioController, "Bio"),
          const SizedBox(height: 12),
          _buildTextField(departmentController, "Department"),
          const SizedBox(height: 12),
          _buildTextField(yearController, "Year of Study"),
          const SizedBox(height: 12),
          _buildTextField(githubController, "GitHub Link"),
          const SizedBox(height: 12),
          _buildTextField(linkedinController, "LinkedIn Link"),
          const SizedBox(height: 12),
          _buildTextField(portfolioController, "Portfolio Link"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final updatedProfile = StudentProfile(
                email: widget.profile.email,
                name: nameController.text,
                skills: skillsController.text.split(",").map((s) => s.trim()).toList(),
                excellence: excellenceController.text,
                bio: bioController.text,
                department: departmentController.text,
                year: yearController.text,
                github: githubController.text,
                linkedin: linkedinController.text,
                portfolio: portfolioController.text,
                profileImagePath: profileImagePath,
              );
              widget.onSave(updatedProfile);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: textLight,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Save"),
          ),
        ]),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.deepPurple.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// -------------------- View Student Profile Page --------------------
class ViewStudentProfilePage extends StatelessWidget {
  final StudentProfile profile;
  final StudentProfile? currentUser;

  const ViewStudentProfilePage(
      {super.key, required this.profile, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        title: Text(profile.name),
        backgroundColor: primaryColor,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
            profile.profileImagePath != null ? FileImage(File(profile.profileImagePath!)) : null,
            backgroundColor: primaryColor.withOpacity(0.7),
            child: profile.profileImagePath == null
                ? Text(profile.name.isNotEmpty ? profile.name[0] : "?", style: TextStyle(fontSize: 28, color: textLight))
                : null,
          ),
          const SizedBox(height: 12),
          Text(profile.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 6),
          Text("${profile.department} • ${profile.year}",
              style: TextStyle(fontSize: 16, color: textDark)),
          const SizedBox(height: 12),
          if (profile.bio.isNotEmpty)
            Text(profile.bio, style: TextStyle(fontSize: 16, color: textDark)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: profile.skills
                .map((skill) => Chip(
              label: Text(skill),
              backgroundColor: accentColor.withOpacity(0.2),
              labelStyle: TextStyle(color: primaryColor),
            ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(profile.excellence,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor)),
          const SizedBox(height: 20),
          ChatPage(profile: profile, currentUser: currentUser),
        ]),
      ),
    );
  }
}

// -------------------- Chat Page --------------------
class ChatPage extends StatefulWidget {
  final StudentProfile profile;
  final StudentProfile? currentUser;

  const ChatPage({super.key, required this.profile, this.currentUser});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<String> messages = [];
  final TextEditingController messageController = TextEditingController();

  void _sendMessage() {
    if (messageController.text.isEmpty) return;
    setState(() {
      messages.add(messageController.text);
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(alignment: Alignment.centerLeft, child: Text("Chat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const SizedBox(height: 10),
        Container(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.5))),
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(messages[index], style: TextStyle(color: textDark)),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.send, color: primaryColor), onPressed: _sendMessage),
          ],
        )
      ],
    );
  }
}
