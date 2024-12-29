import 'package:flutter/material.dart';
import 'todo_task_manager.dart';
import 'budget_tracker.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TrackMate',
          style: TextStyle(
            color: Colors.white, // White color
            fontWeight: FontWeight.bold, // Bold text
            fontSize: 28, // Larger font size
            fontFamily: 'Roboto', // You can replace this with any custom font
            letterSpacing: 1.2, // Slightly increased letter spacing
          ),
        ),
        backgroundColor: Color(0xFF580645), // Dark purple background
        elevation: 0,
        centerTitle: true, // Center the title
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF580645), // Dark Purple Background
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Color(0xFFF4E8FE), // Light Lavender Box Color
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to TrackMate!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TodoTaskManager()),
                        );
                      },
                      text: '📝 Task Manager',
                      backgroundColor: Color(0xFF854488),
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BudgetTracker()),
                        );
                      },
                      text: '💰 Budget Tracker',
                      backgroundColor: Colors.white,
                      textColor: Color(0xFF1E108A),
                      borderColor: Color(0xFF1E108A),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}