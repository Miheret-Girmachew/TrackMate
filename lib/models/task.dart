class Task {
  final String id;
  final String name;
  final String status;
  final String time;
  final String groupId; // Add groupId field

  Task({
    required this.id,
    required this.name,
    required this.status,
    required this.time,
    required this.groupId, // Initialize groupId
  });

  // Add groupId to the fromMap and toMap methods if you have them
}