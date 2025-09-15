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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create Your Account",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
              const SizedBox(height: 30),

              // Full Name
              buildTextField("Full Name", Icons.person, nameController),
              const SizedBox(height: 15),

              // Register Number
              buildTextField("Register Number", Icons.badge, regNoController),
              const SizedBox(height: 15),

              // Mobile
              buildTextField("Mobile Number", Icons.phone, mobileController,
                  inputType: TextInputType.phone),
              const SizedBox(height: 15),

              // Department
              buildTextField("Department", Icons.school, deptController),
              const SizedBox(height: 15),

              // Email
              buildTextField("Email", Icons.email, emailController,
                  inputType: TextInputType.emailAddress),
              const SizedBox(height: 15),

              // Password
              buildTextField("Password", Icons.lock, passwordController,
                  isPassword: true),
              const SizedBox(height: 15),

              // Confirm Password
              buildTextField(
                  "Confirm Password", Icons.lock, confirmController,
                  isPassword: true),
              const SizedBox(height: 25),

              // Sign Up Button
              ElevatedButton(
                onPressed: () {
                  if (passwordController.text == confirmController.text) {
                    String name = nameController.text;
                    String regNo = regNoController.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                          Text("Account Created for $name ($regNo)")),
                    );

                    Navigator.pop(context); // back to login
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ",
                      style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // back to login
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
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

  Widget buildTextField(String label, IconData icon,
      TextEditingController controller,
      {bool isPassword = false,
        TextInputType inputType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
        ),
      ),
    );
  }
}
