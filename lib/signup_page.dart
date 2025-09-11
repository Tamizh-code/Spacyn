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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Signup"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              "Create Your Account",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
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
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Sign Up"),
            )
          ],
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
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}