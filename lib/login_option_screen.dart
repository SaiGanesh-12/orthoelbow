import 'package:flutter/material.dart';
import 'doctor_login_screen.dart'; // Import your doctor login screen file
import 'patient_login_screen.dart'; // Import your patient login screen file

class LoginOptionScreen extends StatefulWidget {
  const LoginOptionScreen({Key? key}) : super(key: key);

  @override
  State<LoginOptionScreen> createState() => _LoginOptionScreenState();
}

class _LoginOptionScreenState extends State<LoginOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Doctor Image and Button
            Column(
              children: [
                Image.asset(
                  'assests/doctor 1.png', // Replace with your doctor image path
                  width: 170,
                  height: 150,
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DoctorLogin()),
                      );
                    },
                    child: Text('Doctor  Login'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            // Patient Image and Button
            Column(
              children: [
                Image.asset(
                  'assests/patient 1.png', // Replace with your patient image path
                  width: 170,
                  height: 150,
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PatientLogin()),
                      );
                    },
                    child: Text('Patient Login'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
