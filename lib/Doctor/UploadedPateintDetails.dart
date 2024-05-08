import 'package:flutter/material.dart';

import 'PatientsTasks/Add task.dart';
import 'PatientsTasks/CaseSheetView.dart';
import 'PatientsTasks/Graphs.dart';
import 'PatientsTasks/PatientsComplaint.dart';
import 'PatientsTasks/PatientsDetailsview.dart';
import 'PatientsTasks/Questionaire.dart';
import 'PatientsTasks/Review.dart';

class PateintDetailUplaoded extends StatefulWidget {
  final String pid;
  const PateintDetailUplaoded({Key? key, required this.pid}) : super(key: key);

  @override
  State<PateintDetailUplaoded> createState() => _PateintDetailUplaodedState();
}

class _PateintDetailUplaodedState extends State<PateintDetailUplaoded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Patient ID',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            Text(
              widget.pid,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Image.asset(
              'assests/logo.png', // Replace 'your_image.png' with your image path
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
            SizedBox(height: 60),
            Container(width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddTask(pid: widget.pid,)),
                  );
                },
                child: Text('Add Task',style: TextStyle(fontSize: 21),),
              ),
            ),
            SizedBox(height: 10),
            Container(width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Patientcomplaint(pid: widget.pid,)),
                  );
                },
                child: Text('Complaints',style: TextStyle(fontSize: 21),),
              ),
            ),
            SizedBox(height: 10),
            Container(width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CaseSheetView(pid: widget.pid,)),
                  );
                },
                child: Text('Case sheet',style: TextStyle(fontSize: 21),),
              ),
            ),
            SizedBox(height: 10),
            Container(width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PatientsDetailsView(pid: widget.pid,)),
                  );
                },
                child: Text('Patients Details',style: TextStyle(fontSize: 21),),
              ),
            ),
            SizedBox(height: 10),
            Container(width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ReviewDr(pid: widget.pid,)),
                  );
                },
                child: Text('Review',style: TextStyle(fontSize: 21),),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => GraphsDr(pid: widget.pid,)),
                  );
                },
                child: Text('Graph',style: TextStyle(fontSize: 21),),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Questionnaire(pid: widget.pid,)),
                  );

                },
                child: Text('Questionaire',style: TextStyle(fontSize: 21),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
