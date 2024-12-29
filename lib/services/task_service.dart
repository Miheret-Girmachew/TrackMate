import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Task>> getTasks(String groupId) {
    return _db
        .collection('tasks')
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task(
                  id: doc.id,
                  name: doc['name'],
                  status: doc['status'],
                  time: doc['time'],
                  groupId: doc['groupId'],
                ))
            .toList());
  }

  Future<void> addTask(Task task) {
    return _db.collection('tasks').add({
      'name': task.name,
      'status': task.status,
      'time': task.time,
      'groupId': task.groupId,
    });
  }

  Future<void> updateTask(String taskId, Task task) {
    return _db.collection('tasks').doc(taskId).update({
      'name': task.name,
      'status': task.status,
      'time': task.time,
      'groupId': task.groupId,
    });
  }

  Future<void> deleteTask(String taskId) {
    return _db.collection('tasks').doc(taskId).delete();
  }

  String generateTaskId() {
    return _db.collection('tasks').doc().id;
  }
}