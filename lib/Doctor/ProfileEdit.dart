import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
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
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userData =
      await _firestore.collection('doctor').doc(uid).get();

      setState(() {
        nameController.text = userData['name'] ?? '';
        ageController.text = userData['age'] ?? '';
        genderController.text = userData['gender'] ?? '';
        qualificationController.text = userData['qualification'] ?? '';
        workingPlaceController.text = userData['working_place'] ?? '';
        emailController.text = userData['email'] ?? '';
        mobileNumberController.text = userData['mobile'] ?? '';
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _updateUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firestore.collection('doctor').doc(uid).update({
        'name': nameController.text,
        'age': ageController.text,
        'gender': genderController.text,
        'qualification': qualificationController.text,
        'working_place': workingPlaceController.text,
        'mobile': mobileNumberController.text,
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
                decoration: InputDecoration(labelText: 'Email'),
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
                decoration: InputDecoration(labelText: 'Qualification'),
                enabled: isEditing,
              ),
              TextFormField(
                controller: workingPlaceController,
                decoration: InputDecoration(labelText: 'Working Place'),
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
