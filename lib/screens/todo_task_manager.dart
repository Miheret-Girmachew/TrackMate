import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/task_group_card.dart';
import '../widgets/motivational_banner.dart';
import 'TaskGroupDetailPage.dart';
import '../models/task.dart' as modelTask;  // Import with prefix to avoid ambiguity
import 'package:uuid/uuid.dart'; // Import UUID package for generating unique IDs

class TodoTaskManager extends StatefulWidget {
  @override
  _TodoTaskManagerState createState() => _TodoTaskManagerState();
}

class _TodoTaskManagerState extends State<TodoTaskManager> {
  List<Map<String, dynamic>> taskGroups = [];
  final Uuid uuid = Uuid(); // Initialize UUID generator

  @override
  void initState() {
    super.initState();
    _loadTaskGroups();
  }

  Future<void> _loadTaskGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? taskGroupsString = prefs.getString('taskGroups');
    if (taskGroupsString != null) {
      setState(() {
        taskGroups = List<Map<String, dynamic>>.from(json.decode(taskGroupsString));
      });
    }
  }

  Future<void> _saveTaskGroups() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('taskGroups', json.encode(taskGroups));
  }

  void addTaskGroup(String name) {
    setState(() {
      taskGroups.add({
        'id': uuid.v4(), // Generate a unique ID for the task group
        'name': name,
        'progress': 0.0,
        'taskCount': 0,
        'tasks': <modelTask.Task>[], // Use List<modelTask.Task>
      });
      _saveTaskGroups();
    });
  }

  void editTaskGroup(int index, String newName) {
    setState(() {
      taskGroups[index]['name'] = newName;
      _saveTaskGroups();
    });
  }

  void deleteTaskGroup(int index) {
    setState(() {
      taskGroups.removeAt(index);
      _saveTaskGroups();
    });
  }

  void updateProgress(int index) {
    List<modelTask.Task> tasks = List<modelTask.Task>.from(taskGroups[index]['tasks']);
    int totalTasks = tasks.length;
    int doneTasks = tasks.where((task) => task.status == 'Done').length;
    double progress = totalTasks > 0 ? doneTasks / totalTasks : 0.0;

    setState(() {
      taskGroups[index]['progress'] = progress;
      _saveTaskGroups();
    });
  }

  void updateTaskCount(int index) {
    List<modelTask.Task> tasks = List<modelTask.Task>.from(taskGroups[index]['tasks']);
    int activeTasks = tasks.where((task) => task.status == 'Undone' || task.status == 'In Progress').length;

    setState(() {
      taskGroups[index]['taskCount'] = activeTasks;
      _saveTaskGroups();
    });
  }

  void showInputDialog({required Function(String) onSubmit, String initialText = ''}) {
    TextEditingController controller = TextEditingController(text: initialText);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(initialText.isEmpty ? 'Add Task Group' : 'Edit Task Group'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter task group name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  onSubmit(controller.text);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Task group name cannot be empty'),
                  ));
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showProgressDialog(int index) {
    TextEditingController progressController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Progress'),
          content: TextField(
            controller: progressController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter progress (0.0 to 1.0)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                double newProgress = double.tryParse(progressController.text) ?? 0.0;
                updateProgress(index);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo Task Manager',
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
                      'Task Groups',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: taskGroups.length,
                      itemBuilder: (context, index) {
                        final group = taskGroups[index];
                        return TaskGroupCard(
                          groupName: group['name'],
                          groupId: group['id'], // Pass groupId
                          taskCount: group['taskCount'],
                          progress: group['progress'],
                          color: Colors.orange,
                          onEdit: () {
                            showInputDialog(
                              initialText: group['name'],
                              onSubmit: (newName) => editTaskGroup(index, newName),
                            );
                          },
                          onDelete: () => deleteTaskGroup(index),
                          onUpdate: () {
                            updateProgress(index);
                            updateTaskCount(index);
                          },
                          tasks: List<modelTask.Task>.from(group['tasks'] ?? []),  // Use List<modelTask.Task>
                          onTasksUpdated: (updatedTasks) {
                            setState(() {
                              taskGroups[index]['tasks'] = updatedTasks;
                              updateProgress(index);
                              updateTaskCount(index);
                              _saveTaskGroups();
                            });
                          },
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        showInputDialog(onSubmit: addTaskGroup);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF580645), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text('Add Task Group'),
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