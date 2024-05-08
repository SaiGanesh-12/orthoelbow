import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class PEditProfile extends StatefulWidget {
  final String pid;
  const PEditProfile({Key? key, required this.pid}) : super(key: key);

  @override
  State<PEditProfile> createState() => _PEditProfileState();
}

class _PEditProfileState extends State<PEditProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController workingPlaceController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {

      DocumentSnapshot userData =
      await _firestore.collection('patients').doc(widget.pid).get();

      setState(() {
        nameController.text = userData['name'] ?? '';
        ageController.text = userData['age'] ?? '';
        genderController.text = userData['gender'] ?? '';
        qualificationController.text = userData['weight'] ?? '';
        workingPlaceController.text = userData['height'] ?? '';
        emailController.text = userData['pid'] ?? '';
        mobileNumberController.text = userData['num'] ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('patients').doc(widget.pid).update({
        'name': nameController.text,
        'age': ageController.text,
        'gender': genderController.text,
        'weight': qualificationController.text,
        'height': workingPlaceController.text,
        'occupation': mobileNumberController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      setState(() {
        isEditing = false;
      });
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                enabled: isEditing,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'PID'),
                enabled: false,
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender'),
                enabled: isEditing,
              ),
              TextFormField(
                controller: mobileNumberController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                enabled: isEditing,
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                enabled: isEditing,
              ),
              TextFormField(
                controller: qualificationController,
                decoration: InputDecoration(labelText: 'Weight'),
                enabled: isEditing,
              ),
              TextFormField(
                controller: workingPlaceController,
                decoration: InputDecoration(labelText: 'Height'),
                enabled: isEditing,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditing = !isEditing;
            if (!isEditing) {
              _updateUserData();
            }
          });
        },
        child: isEditing ? Icon(Icons.save) : Icon(Icons.edit),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
