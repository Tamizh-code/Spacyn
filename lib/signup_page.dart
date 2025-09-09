import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: const Text("Signup"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    "Create Your Account",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightGreen),
                  ),
                  const SizedBox(height: 20),
                  buildTextField("Full Name", Icons.person, nameController),
                  const SizedBox(height: 15),
                  buildTextField("Register Number", Icons.badge, regNoController),
                  const SizedBox(height: 15),
                  buildTextField("Mobile Number", Icons.phone, mobileController,
                      inputType: TextInputType.phone),
                  const SizedBox(height: 15),
                  buildTextField("Department", Icons.school, deptController),
                  const SizedBox(height: 15),
                  buildTextField("Email", Icons.email, emailController),
                  const SizedBox(height: 15),
                  buildTextField("Password", Icons.lock, passwordController,
                      isPassword: true),
                  const SizedBox(height: 15),
                  buildTextField("Confirm Password", Icons.lock, confirmController,
                      isPassword: true),
                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: () {
                      if (passwordController.text == confirmController.text) {
                        String name = nameController.text;
                        String regNo = regNoController.text;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Account Created for $name ($regNo)")),
                        );

                        Navigator.pop(context); // back to login
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Passwords do not match")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.blueGrey,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Sign Up"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, IconData icon,
      TextEditingController controller,
      {bool isPassword = false, TextInputType inputType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
