import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/Login.dart';  // Import LoginScreen widget
import 'screens/home_screen.dart';   // Import HomeScreen widget
import 'screens/Signup.dart' as custom;  // Import SignupScreen with alias

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyCuy6CfRi9PolBewvx03xQ_XCd_R8BG-x4",  // Your Firebase API key
        authDomain: "trackmate-7313a.firebaseapp.com",      // Your Firebase Auth domain
        projectId: "trackmate-7313a",                       // Your Firebase Project ID
        storageBucket: "trackmate-7313a.appspot.com",       // Corrected Firebase Storage bucket
        messagingSenderId: "330700524167",                  // Your Firebase Messaging sender ID
        appId: "1:330700524167:web:a0cd1f223912a77d470622", // Your Firebase App ID
        measurementId: "G-EYCCJ3SDQM",                      // Your Firebase Measurement ID (optional)
      ),
    );
    print("Firebase initialized successfully");
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  runApp(TrackMateApp());
}

class TrackMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackMate',
      theme: ThemeData(
        primaryColor: const Color(0xFF580645),  // Updated primary color
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFFF4E8FE),  // Adjusted secondary color
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF580645),  // Set primary color for AppBar
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF580645),  // Set button color to match primary color
        ),
        // Optionally, add additional theme customizations here.
      ),
      initialRoute: '/login',  // Set Login screen as the starting page
      routes: {
        '/login': (context) => LoginScreen(),   // Named route for Login screen
        '/signUp': (context) => custom.SignUpScreen(), // Named route for Sign Up screen with alias
        '/home': (context) => HomeScreen(),     // Named route for Home screen after login
      },
    );
  }
}