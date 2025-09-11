import 'package:flutter/material.dart';

// -------------------- Stud Media Page --------------------
class StudMediaHomePage extends StatefulWidget {
  final String userEmail; // unique identifier for current user

  const StudMediaHomePage({super.key, required this.userEmail});

  @override
  State<StudMediaHomePage> createState() => _StudMediaHomePageState();
}

class _StudMediaHomePageState extends State<StudMediaHomePage> {
  List<StudentProfile> profiles = [
    StudentProfile(
      email: "alice@example.com",
      name: "Alice Johnson",
      skills: ["Flutter", "Python", "UI/UX Design"],
      excellence: "Won 1st prize in Hackathon 2025",
    ),
    StudentProfile(
      email: "bob@example.com",
      name: "Bob Smith",
      skills: ["Java", "C++", "Machine Learning"],
      excellence: "Published research in AI Journal",
    ),
  ];

  StudentProfile? getCurrentUserProfile() {
    try {
      return profiles.firstWhere((p) => p.email == widget.userEmail);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserProfile = getCurrentUserProfile();

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        title: const Text("Stud Media"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (currentUserProfile == null)
              ElevatedButton.icon(
                onPressed: () {
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
                },
                icon: const Icon(Icons.add),
                label: const Text("Create Your Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: profiles.length,
                itemBuilder: (context, index) {
                  final profile = profiles[index];
                  final isCurrentUser = profile.email == widget.userEmail;

                  return Stack(
                    children: [
                      StudentProfileCard(profile: profile),
                      if (isCurrentUser)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
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
                              },
                            ),
                          ),
                        ),
                    ],
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

// -------------------- Student Profile Model --------------------
class StudentProfile {
  String email;
  String name;
  List<String> skills;
  String excellence;

  StudentProfile({
    required this.email,
    required this.name,
    required this.skills,
    required this.excellence,
  });
}

// -------------------- Profile Card --------------------
class StudentProfileCard extends StatelessWidget {
  final StudentProfile profile;
  const StudentProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.deepPurple.shade200,
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
                backgroundColor: Colors.deepPurple.shade300,
                child: Text(
                  profile.name.isNotEmpty ? profile.name[0] : "?",
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                profile.name.isNotEmpty ? profile.name : "No Name",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: profile.skills
                .map((skill) => Chip(
              label: Text(skill),
              backgroundColor: Colors.deepPurple.shade100,
              labelStyle: const TextStyle(color: Colors.deepPurple),
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
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple),
                ),
              ),
            ],
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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    skillsController =
        TextEditingController(text: widget.profile.skills.join(", "));
    excellenceController =
        TextEditingController(text: widget.profile.excellence);
  }

  @override
  void dispose() {
    nameController.dispose();
    skillsController.dispose();
    excellenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: Colors.deepPurple,
          elevation: 4),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Name",
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: skillsController,
              decoration: InputDecoration(
                  labelText: "Skills (comma separated)",
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: excellenceController,
              decoration: InputDecoration(
                  labelText: "Excellence / Achievements",
                  filled: true,
                  fillColor: Colors.deepPurple.shade50,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final updatedProfile = StudentProfile(
                  email: widget.profile.email,
                  name: nameController.text,
                  skills: skillsController.text
                      .split(",")
                      .map((s) => s.trim())
                      .toList(),
                  excellence: excellenceController.text,
                );
                widget.onSave(updatedProfile);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
