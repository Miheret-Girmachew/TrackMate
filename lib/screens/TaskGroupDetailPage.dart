import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskGroupDetailPage extends StatefulWidget {
  final String groupName;
  final String groupId; // Add groupId
  final List<Task> tasks;
  final Function(List<Task>) onTasksUpdated;

  TaskGroupDetailPage({
    required this.groupName,
    required this.groupId, // Initialize groupId
    required this.tasks,
    required this.onTasksUpdated,
  });

  @override
  _TaskGroupDetailPageState createState() => _TaskGroupDetailPageState();
}

class _TaskGroupDetailPageState extends State<TaskGroupDetailPage> {
  TextEditingController taskController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final TaskService _taskService = TaskService();

  void addTask() async {
    if (taskController.text.isNotEmpty && timeController.text.isNotEmpty) {
      Task newTask = Task(
        id: _taskService.generateTaskId(), // Generate a unique ID for the task
        name: taskController.text.trim(),
        status: 'Undone',
        time: timeController.text.trim(),
        groupId: widget.groupId, // Set groupId
      );
      await _taskService.addTask(newTask);
      taskController.clear();
      timeController.clear();
      _updateTasks();
    }
  }

  void editTask(String taskId, Task task) async {
    taskController.text = task.name;
    timeController.text = task.time;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Task updatedTask = Task(
                  id: task.id, // Use the existing task ID
                  name: taskController.text.trim(),
                  status: task.status,
                  time: timeController.text.trim(),
                  groupId: task.groupId, // Keep the same groupId
                );
                await _taskService.updateTask(taskId, updatedTask);
                taskController.clear();
                timeController.clear();
                Navigator.pop(context);
                _updateTasks();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void deleteTask(String taskId) async {
    await _taskService.deleteTask(taskId);
    _updateTasks();
  }

  void _updateTasks() async {
    List<Task> tasks = await _taskService.getTasks(widget.groupId).first;
    widget.onTasksUpdated(tasks);
  }

  Widget taskList(String status, Color color) {
    return StreamBuilder<List<Task>>(
      stream: _taskService.getTasks(widget.groupId), // Filter tasks by groupId
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        List<Task> filteredTasks = snapshot.data?.where((task) => task.status == status).toList() ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$status Tasks:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 10),
            ...filteredTasks.map((task) {
              String taskId = task.id; // Assuming Task model has an id field
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.task, color: color),
                  title: Text(task.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time: ${task.time}'),
                      DropdownButton<String>(
                        value: task.status,
                        items: ['Undone', 'In Progress', 'Done']
                            .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                            .toList(),
                        onChanged: (newStatus) async {
                          if (newStatus != null) {
                            Task updatedTask = Task(
                              id: task.id,
                              name: task.name,
                              status: newStatus,
                              time: task.time,
                              groupId: task.groupId, // Keep the same groupId
                            );
                            await _taskService.updateTask(taskId, updatedTask);
                            _updateTasks();
                          }
                        },
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => editTask(taskId, task),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTask(taskId),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
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
          '${widget.groupName} Tasks',
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
                    taskList('Undone', Colors.red),
                    const SizedBox(height: 20),
                    taskList('In Progress', Colors.blue),
                    const SizedBox(height: 20),
                    taskList('Done', Colors.green),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: taskController,
                            decoration: InputDecoration(
                              labelText: 'Task Name',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            decoration: InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: addTask,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            backgroundColor: Color(0xFF580645),
                          ),
                          child: const Text('Add'),
                        ),
                      ],
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