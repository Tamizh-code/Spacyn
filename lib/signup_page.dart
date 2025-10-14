import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A0DAD), Color(0xFF1E90FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Create Your Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                buildTextField("Full Name", Icons.person, nameController),
                const SizedBox(height: 15),

                buildTextField("Register Number", Icons.badge, regNoController),
                const SizedBox(height: 15),

                buildTextField("Mobile Number", Icons.phone, mobileController,
                    inputType: TextInputType.phone),
                const SizedBox(height: 15),

                buildTextField("Department", Icons.school, deptController),
                const SizedBox(height: 15),

                buildTextField("Email", Icons.email, emailController,
                    inputType: TextInputType.emailAddress),
                const SizedBox(height: 15),

                buildTextField("Password", Icons.lock, passwordController,
                    isPassword: true),
                const SizedBox(height: 15),

                buildTextField("Confirm Password", Icons.lock, confirmController,
                    isPassword: true),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () async {
                    if (passwordController.text == confirmController.text) {
                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Account Created Successfully")),
                        );

                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message ?? "Sign up failed")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 8,
                    shadowColor: Colors.black54,
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? ",
                        style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, IconData icon, TextEditingController controller,
      {bool isPassword = false, TextInputType inputType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white70),
        ),
      ),
    );
  }
}
