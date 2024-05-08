import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Admin/AdminScreenPage.dart';
import 'Doctor/DoctorhomeScreen.dart';


class DoctorLogin extends StatefulWidget {
  const DoctorLogin({Key? key}) : super(key: key);

  @override
  State<DoctorLogin> createState() => _DoctorLoginState();
}

class _DoctorLoginState extends State<DoctorLogin> {
  TextEditingController doctorIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _signIn() async {


    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: doctorIDController.text.trim(),
        password: passwordController.text.trim(),
      );



      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DoctorDashboard()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      print("Firebase Auth Error: $e");
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.message}"),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      // Handle other errors
      print("Error: $e");
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Doctor Login'),
      ),
      backgroundColor: Colors.teal[400],
      body: Center(
        child: Container(
          width: 350,
          height: 350,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Doctor ID TextField
              TextField(
                controller: doctorIDController,
                decoration: InputDecoration(
                  hintText: 'Doctor ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              // Login Button
              Container(
                width: 250,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[400],
                    foregroundColor: Colors.black,

                  ),
                  onPressed: () {
                    String doctorID = doctorIDController.text.trim();
                    String password = passwordController.text.trim();

                    // Check if Doctor ID is "admin" and password is "admin123"
                    if (doctorID == 'admin' && password == 'admin123') {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AdminScreen()),
                      );
                    } else {
                      _signIn();

                    }
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
