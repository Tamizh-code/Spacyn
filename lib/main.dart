import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_page.dart';
import 'home_page.dart'; // import your HomePage

// Import kIsWeb to detect platform
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Initialize with your web config here — replace values below with your actual Firebase config
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAPtOQxcARjXFZq5uNCGj7AqswgIPYrd0Q",
        authDomain: "spacyn-tdkhd.firebaseapp.com",
        projectId: "spacyn-tdkhd",
        storageBucket: "spacyn-tdkhd.appspot.com",
        messagingSenderId: "107045093324",
        appId: "1:107045093324:web:YOUR_WEB_APP_ID", // Replace with your actual Web App ID
        measurementId: "G-XXXXXXXXXX", // optional
      ),
    );
  } else {
    // Mobile and desktop initialization
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login & Signup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const AuthWrapper(), // Use auth state wrapper
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          // User is logged in
          return HomePage(userEmail: snapshot.data!.email ?? "No Email");
        } else {
          // User is NOT logged in
          return const LoginPage();
        }
      },
    );
  }
}
