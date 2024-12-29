import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlannedBudgetPage extends StatefulWidget {
  @override
  _PlannedBudgetPageState createState() => _PlannedBudgetPageState();
}

class _PlannedBudgetPageState extends State<PlannedBudgetPage> {
  final List<Map<String, dynamic>> _plannedBudgets = [];
  final _countController = TextEditingController();
  final _reasonController = TextEditingController();
  final _dueDateController = TextEditingController();
  int? _editingIndex;  // Variable to track the index of the planned budget being edited

  @override
  void initState() {
    super.initState();
    _loadPlannedBudgets();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _countController.dispose();
    _reasonController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _loadPlannedBudgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? plannedBudgetsString = prefs.getString('plannedBudgets');
    if (plannedBudgetsString != null) {
      setState(() {
        _plannedBudgets.addAll(List<Map<String, dynamic>>.from(json.decode(plannedBudgetsString)));
      });
    }
  }

  Future<void> _savePlannedBudgets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('plannedBudgets', json.encode(_plannedBudgets));
  }

  void _addPlannedBudget() {
    final count = int.tryParse(_countController.text);
    final reason = _reasonController.text;
    final dueDate = _dueDateController.text;

    if (count != null && reason.isNotEmpty && dueDate.isNotEmpty) {
      if (_editingIndex == null) {
        // Add new planned budget
        setState(() {
          _plannedBudgets.add({
            'count': count,
            'reason': reason,
            'dueDate': dueDate,
          });
        });
      } else {
        // Edit existing planned budget
        setState(() {
          _plannedBudgets[_editingIndex!] = {
            'count': count,
            'reason': reason,
            'dueDate': dueDate,
          };
          _editingIndex = null;
        });
      }
      _countController.clear();
      _reasonController.clear();
      _dueDateController.clear();
      _savePlannedBudgets();
    }
  }

  void _editPlannedBudget(int index) {
    setState(() {
      _countController.text = _plannedBudgets[index]['count'].toString();
      _reasonController.text = _plannedBudgets[index]['reason'];
      _dueDateController.text = _plannedBudgets[index]['dueDate'];
      _editingIndex = index;
    });
  }

  void _deletePlannedBudget(int index) {
    setState(() {
      _plannedBudgets.removeAt(index);
      _savePlannedBudgets();
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dueDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Planned Budget',
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
                    TextField(
                      controller: _countController,
                      decoration: InputDecoration(
                        labelText: 'Sample Number (Count)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        labelText: 'Reason',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _dueDateController,
                            decoration: InputDecoration(
                              labelText: 'Due Date',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDueDate(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addPlannedBudget,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF580645), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Text(_editingIndex == null ? 'Add Planned Budget' : 'Update Planned Budget'),
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _plannedBudgets.length,
                      itemBuilder: (context, index) {
                        final plannedBudget = _plannedBudgets[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text('${plannedBudget['count']} - ${plannedBudget['reason']}'),
                            subtitle: Text('Due Date: ${plannedBudget['dueDate']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _editPlannedBudget(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletePlannedBudget(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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