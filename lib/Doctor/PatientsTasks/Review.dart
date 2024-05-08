import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../DoctorhomeScreen.dart';

class ReviewDr extends StatefulWidget {
  final String pid;
  const ReviewDr({Key? key, required this.pid}) : super(key: key);

  @override
  State<ReviewDr> createState() => _ReviewDrState();
}

class _ReviewDrState extends State<ReviewDr> {
  late ImagePicker _picker;
  //String _image;
  late String photoUrl;
  double totalScore = 0; // Initial value for total score
  late TextEditingController dateController;
  late TextEditingController admissionDateController;
  late TextEditingController surgeryDateController;
  late TextEditingController postOpDayController;
  late TextEditingController woundStatusController;
  late TextEditingController rangeOfMovementsController;
  late TextEditingController flexionController;
  late TextEditingController extensionController;
  late TextEditingController internalRotationController;
  late TextEditingController externalRotationController;
  late TextEditingController pronationController;
  late TextEditingController supinationController;
  late TextEditingController asesScoreController;
  late TextEditingController mayoElbowScoreController;

  bool isSubmitting=false;

  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();
    dateController = TextEditingController();
    admissionDateController = TextEditingController();
    surgeryDateController = TextEditingController();
    postOpDayController = TextEditingController();
    woundStatusController = TextEditingController();
    rangeOfMovementsController = TextEditingController();
    flexionController = TextEditingController();
    extensionController = TextEditingController();
    internalRotationController = TextEditingController();
    externalRotationController = TextEditingController();
    pronationController = TextEditingController();
    supinationController = TextEditingController();
    asesScoreController = TextEditingController();
    mayoElbowScoreController = TextEditingController();
    photoUrl='';
    fetchUserData();
    fetchReviewData();

  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> fetchReviewData() async {
    try {
      String pid = widget.pid;
      // Fetch review data from Firestore
      DocumentSnapshot reviewData = await FirebaseFirestore.instance
          .collection('reviews')
          .doc(pid)
          .get();

      setState(() {
        // Extract photo URL from review data
         photoUrl = reviewData['imageUrl'] ?? '';
         postOpDayController.text=reviewData['postOpDate'];

        if (photoUrl.isNotEmpty) {
          print("hjhv"+photoUrl);
        }
        print(photoUrl);
      });
    } catch (e) {
      print('Error fetching review data: $e');
    }
  }
  Future<void> fetchUserData() async {
    try {
      String uid =widget.pid;
      DocumentSnapshot userData =
      await _firestore.collection('patients').doc(uid).get();


      DocumentSnapshot data =
      await _firestore.collection('reviews').doc(uid).get();

      setState(() {
        admissionDateController.text = userData['DOA'] ?? '';
        surgeryDateController.text = userData['DOS'] ?? '';
        mayoElbowScoreController.text=userData['Mayo Elbow']?? '';
        asesScoreController.text=userData['ASES']??'';


        final postOpDate = DateTime.now()
            .difference(DateTime.parse(userData?['DOS'] ?? ''))
            .inDays;
        postOpDayController.text =data['postOpDate'];
        print(postOpDate);

      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }


  Future<void> addReviewDataToFirestore() async {
    try {

      setState(() {
        isSubmitting = true; // Set submitting flag to true
      });
      String pid = widget.pid;


      if (woundStatusController.text.isEmpty &&
          rangeOfMovementsController.text.isEmpty &&
          flexionController.text.isEmpty &&
          extensionController.text.isEmpty &&
          internalRotationController.text.isEmpty &&
          externalRotationController.text.isEmpty &&
          pronationController.text.isEmpty &&
          supinationController.text.isEmpty) {

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please provide values for all fields.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isSubmitting=false;
                    });// Close the popup
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );


      }

     else if (asesScoreController.text.isEmpty ||
          mayoElbowScoreController.text.isEmpty) {
        // Show a popup if either of them is empty
        isSubmitting=false;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please provide values for ASES Score and Mayo Elbow Score.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isSubmitting=false;
                    });// Close the popup
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

     }

      else{
        Map<String, dynamic> updateData = {
          'woundStatus': FieldValue.arrayUnion([woundStatusController.text]),
          'rangeOfMovements': FieldValue.arrayUnion([rangeOfMovementsController.text]),
          'flexion': FieldValue.arrayUnion([flexionController.text]),
          'extension': FieldValue.arrayUnion([extensionController.text]),
          'internalRotation': FieldValue.arrayUnion([internalRotationController.text]),
          'externalRotation': FieldValue.arrayUnion([externalRotationController.text]),
          'pronation': FieldValue.arrayUnion([pronationController.text]),
          'supination': FieldValue.arrayUnion([supinationController.text]),
        };

        await FirebaseFirestore.instance.collection('reviews').doc(pid).update(updateData);


        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DoctorDashboard(),
        ));

        print('Review data updated successfully');
      }
    } catch (e) {
      print('Error updating review data: $e');
    }
  }






  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
     // _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0DA7A7),
      appBar: AppBar(
        title: Text(
          "Review",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 10),
              Row(
                children: [

                  Expanded(
                    flex: 2,
                    child: Text(
                      'Date of Admission:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: admissionDateController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Date of Surgery:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: surgeryDateController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Post-op-day:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: postOpDayController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Clinical Photos:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (photoUrl.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenPhoto(
                              photoUrl: photoUrl,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 200,
                      width: 200, // Set the width to create a square
                      color: Colors.grey[300],
                      child: photoUrl == null || photoUrl.isEmpty
                          ? Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 50,
                        ),
                      )
                          : Hero(
                        tag: 'profilePhoto',
                        child: CircleAvatar(
                          radius: 100, // Adjust the radius for a larger CircleAvatar
                          backgroundImage: NetworkImage(photoUrl),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Wound Status:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: woundStatusController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Range of Movement\'s:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: rangeOfMovementsController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Flexion:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: flexionController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Extension:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: extensionController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Internal Rotation:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: internalRotationController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'External Rotation:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: externalRotationController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Pronation:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: pronationController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Supination:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: supinationController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'ASES Score:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: asesScoreController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Mayo Elbow Score:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: mayoElbowScoreController,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Text(
              //         'Total Score:',
              //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Text(
              //         totalScore.toStringAsFixed(2), // Display total score with 2 decimal places
              //         style: TextStyle(fontSize: 16),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width:250,
                        child: ElevatedButton(
                          onPressed: isSubmitting
                              ? null
                              : addReviewDataToFirestore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal[400],
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (isSubmitting) CircularProgressIndicator(), // Show circular progress if submitting
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class FullScreenPhoto extends StatelessWidget {
  final String photoUrl;

  const FullScreenPhoto({Key? key, required this.photoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Photo'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back when the photo is tapped
          },
          child: Hero(
            tag: 'profilePhoto',
            child: Image.network(photoUrl),
          ),
        ),
      ),
    );
  }
}