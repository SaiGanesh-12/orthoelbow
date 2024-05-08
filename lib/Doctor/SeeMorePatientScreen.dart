import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orthoflexelbow/Doctor/UploadedPateintDetails.dart';

class SeeMorePatientScreen extends StatefulWidget {
  const SeeMorePatientScreen({Key? key}) : super(key: key);

  @override
  State<SeeMorePatientScreen> createState() => _SeeMorePatientScreenState();
}

class _SeeMorePatientScreenState extends State<SeeMorePatientScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<DocumentSnapshot> patients;
  late List<DocumentSnapshot> filteredPatients;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('patients').get();
      setState(() {
        patients = snapshot.docs;
        filteredPatients = patients;
      });
    } catch (e) {
      print('Error fetching patients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by PID',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                filterPatients(value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                var data = filteredPatients[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(data['photoUrl']),
                    ),
                    title: Text(data['name']),
                    subtitle: Text('PID: ${data['pid']}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PateintDetailUplaoded(pid: data['pid']),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void filterPatients(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredPatients = patients.where((patient) {
          String pid = patient['pid'].toString().toLowerCase();
          return pid.contains(query.toLowerCase());
        }).toList();
      });
    } else {
      setState(() {
        filteredPatients = patients;
      });
    }
  }
}
