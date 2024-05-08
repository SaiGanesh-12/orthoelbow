import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../DoctorhomeScreen.dart';



class Questionnaire extends StatefulWidget {
  final String pid;
  const Questionnaire({Key? key, required this.pid}) : super(key: key);

  @override
  State<Questionnaire> createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  int totalScore = 0; // Variable to store the total score
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // State variables to track checkbox states
  Map<String, bool> checkboxValues = {
    'none': false,
    'mild': false,
    'moderate': false,
    'severe': false,
    'arc100': false,
    'arc50': false,
    'arcLess50': false,
    'stable': false,
    'moderateInstability': false,
    'grosslyUnstable': false,
    'combHair': false,
    'eat': false,
    'hygiene': false,
    'putOnShirt': false,
    'putOnShoe': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mayo Elbow Score'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MAYO ELBOW SCORE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildPainIntensitySection(),
              SizedBox(height: 20),
              _buildMotionSection(),
              SizedBox(height: 20),
              _buildStabilitySection(),
              SizedBox(height: 20),
              _buildFunctionSection(),
              SizedBox(height: 20),
              Text(
                'PID: ${widget.pid}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total Score: $totalScore',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 250,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[400],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _saveTotalScore();
                    },
                    child: Text('Save Score'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPainIntensitySection() {
    return _buildCheckboxSection(
      'Pain Intensity',
      ['none', 'mild', 'moderate', 'severe'],
      [45, 30, 15, 0],
    );
  }

  Widget _buildMotionSection() {
    return _buildCheckboxSection(
      'Motion',
      ['arc100', 'arc50', 'arcLess50'],
      [20, 15, 5],
    );
  }

  Widget _buildStabilitySection() {
    return _buildCheckboxSection(
      'Stability',
      ['stable', 'moderateInstability', 'grosslyUnstable'],
      [10, 5, 0],
    );
  }

  Widget _buildFunctionSection() {
    return _buildCheckboxSection(
      'Function (tick as many as able)',
      ['combHair', 'eat', 'hygiene', 'putOnShirt', 'putOnShoe'],
      [5, 5, 5, 5, 5],
    );
  }

  Widget _buildCheckboxSection(
      String title, List<String> keys, List<int> scores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ...keys.map((key) {
          return CheckboxListTile(
            title: Text(_getCheckboxTitle(key)),
            value: checkboxValues[key] ?? false,
            onChanged: (value) {
              setState(() {
                checkboxValues[key] = value!;
                _updateScore(value, scores[keys.indexOf(key)]);
              });
            },
          );
        }).toList(),
      ],
    );
  }

  String _getCheckboxTitle(String key) {
    switch (key) {
      case 'none':
        return 'None (45)';
      case 'mild':
        return 'Mild (30)';
      case 'moderate':
        return 'Moderate (15)';
      case 'severe':
        return 'Severe (0)';
      case 'arc100':
        return 'Arc of motion > 100 degrees (20)';
      case 'arc50':
        return 'Arc of motion 50-100 degrees (15)';
      case 'arcLess50':
        return 'Arc of motion < 50 degrees (5)';
      case 'stable':
        return 'Stable (10)';
      case 'moderateInstability':
        return 'Moderate instability (5)';
      case 'grosslyUnstable':
        return 'Grossly Unstable (0)';
      case 'combHair':
        return 'Can comb hair (5)';
      case 'eat':
        return 'Can eat (5)';
      case 'hygiene':
        return 'Can perform hygiene (5)';
      case 'putOnShirt':
        return 'Can put on shirt (5)';
      case 'putOnShoe':
        return 'Can put on shoe (5)';
      default:
        return '';
    }
  }

  void _updateScore(bool value, int score) {
    setState(() {
      if (value) {
        totalScore += score;
      } else {
        totalScore -= score;
      }
    });
  }

  Future<void> _saveTotalScore() async {
    try {


      // Save patient details with photo URL to Firestore
      String pid = widget.pid;
      await _firestore.collection('patients').doc(pid).update({
        'Mayo Elbow':totalScore.toString()
      });

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DoctorDashboard(),
      ));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient details saved successfully')),
      );


    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save patient details'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}