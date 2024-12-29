import 'package:flutter/material.dart';
import '../screens/TaskGroupDetailPage.dart';
import '../models/task.dart'; // Import the shared Task class

class TaskGroupCard extends StatelessWidget {
  final String groupName;
  final String groupId; // Add groupId
  final int taskCount;
  final double progress;
  final Color color;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;
  final List<Task> tasks; // Use the Task class from task.dart
  final Function(List<Task>) onTasksUpdated;

  TaskGroupCard({
    required this.groupName,
    required this.groupId, // Initialize groupId
    required this.taskCount,
    required this.progress,
    required this.color,
    required this.onEdit,
    required this.onDelete,
    required this.onUpdate,
    required this.tasks,
    required this.onTasksUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskGroupDetailPage(
              groupName: groupName,
              groupId: groupId, // Pass groupId
              tasks: tasks, // Pass tasks directly
              onTasksUpdated: onTasksUpdated, // Pass the correct update callback
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: const Icon(Icons.work, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '$taskCount Tasks',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Progress: ${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
        
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}