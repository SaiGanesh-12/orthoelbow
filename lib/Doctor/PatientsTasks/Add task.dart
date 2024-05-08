import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../DoctorhomeScreen.dart';

class AddTask extends StatefulWidget {
  final String pid;

  const AddTask({Key? key, required this.pid}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _fetchSelectedOptions();
  }

  void _fetchSelectedOptions() async {
    try {
      final docSnapshot =
      await FirebaseFirestore.instance.collection('patients').doc(widget.pid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final tasks = List<String>.from(data['Add Task']);
        setState(() {
          selectedOptions = tasks;
        });
      }
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        elevation: 0,
      ),
      backgroundColor: Colors.teal[400],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildOption('FLEXION'),
                  _buildOption('EXTENSION'),
                  _buildOption('PRONATION'),
                  _buildOption('SUPINATION'),
                  _buildOption('INTERNAL ROTATION'),
                  _buildOption('EXTERNAL ROTATION'),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    _saveSelectedOptions();
                  },
                  child: Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    return ListTile(
      title: Text(
        option,
        style: TextStyle(color: Colors.black, fontSize: 22),
      ),
      trailing: Checkbox(
        value: selectedOptions.contains(option),
        checkColor: Colors.black,

        onChanged: (isChecked) {
          setState(() {
            if (isChecked!) {
              selectedOptions.add(option); // Add the option if checked
            } else {
              selectedOptions.remove(option); // Remove the option if unchecked
            }
          });
        },
      ),
    );
  }



  void _saveSelectedOptions() {
    FirebaseFirestore.instance
        .collection('patients')
        .doc(widget.pid)
        .update({'Add Task': selectedOptions})
        .then((_) {

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DoctorDashboard(),
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tasks updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update tasks: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
