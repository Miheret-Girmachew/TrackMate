import 'package:flutter/material.dart';

class MotivationalBanner extends StatelessWidget {
  final List<Map<String, dynamic>> taskGroups;

  MotivationalBanner({required this.taskGroups});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centers horizontally
        crossAxisAlignment: CrossAxisAlignment.center, // Centers vertically
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers content in Column
            crossAxisAlignment: CrossAxisAlignment.center, // Centers text and button in Column
            children: [
              Text(
                "You're doing amazing!\nKeep conquering your goals!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center, // Centers the text content
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Stay Motivated',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
