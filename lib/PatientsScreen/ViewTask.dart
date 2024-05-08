import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'PatientHomeScreen.dart';

class ViewTask extends StatefulWidget {
  final String pid;
  const ViewTask({Key? key, required this.pid}) : super(key: key);

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  List<String> taskList = [];
  late List<bool> taskSelections;

  @override
  void initState() {
    super.initState();
    _fetchTaskList();
  }

  Future<void> _fetchTaskList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('patients')
          .doc(widget.pid)
          .get();
      if (snapshot.exists) {
        setState(() {
          taskList = List<String>.from(snapshot.data()?['Add Task'] ?? []);
          taskSelections = List<bool>.filled(taskList.length, false);
        });
      }
    } catch (e) {
      print('Error fetching task list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],
      appBar: AppBar(
        title: Text('View Tasks'),
      ),
      body: ListView.builder(
        itemCount: taskList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(taskList[index]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: taskSelections[index],
                  onChanged: (newValue) {
                    setState(() {
                      taskSelections[index] = newValue!;
                      if (newValue) {
                        taskSelections[index ^ 1] = !newValue;
                      }
                    });
                  },
                ),
                Text('Yes'),
                Checkbox(
                  value: !taskSelections[index],
                  onChanged: (newValue) {
                    setState(() {
                      taskSelections[index] = !newValue!;
                      if (newValue!) {
                        taskSelections[index ^ 1] = newValue;
                      }
                    });
                  },
                ),
                Text('No'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement submit logic here
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PatientHomeScreen(pid: widget.pid),
            ),
          );
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
