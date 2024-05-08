import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:orthoflexelbow/PatientsScreen/PatientHomeScreen.dart';



class Quiz extends StatefulWidget {
  final String pid;
  const Quiz({Key? key, required this.pid}) : super(key: key);

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  final TextEditingController usualWorkController = TextEditingController();
  final TextEditingController usualSportController = TextEditingController();
  String painAtNight = "";
  String painKiller1 = "";
  String painKiller2 = "";
  String pills = "";
  double _sliderValue = 5.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Question> _questions = [
    Question(
        '8. Is it difficult for you to put on a coat? (கோட் போடுவதில் கஷ்டமா?'),
    Question(
        '9. Is it difficult for you to sleep on the affected side? (பாதிக்கப்பட்ட பக்கத்தில் தூங்குவது உங்களுக்கு கடினமாக உள்ளதா?)'),
    Question(
        '10. Is it difficult for you to wash your back? (உங்கள் முதுகைக் கழுவுவது உங்களுக்கு கடினமாக இருக்கிறதா?)'),
    Question(
        '11. Is it difficult for you to manage toileting?(கழிப்பறையை நிர்வகிப்பது உங்களுக்கு கடினமாக உள்ளதா?)'),
    Question(
        '12. Is it difficult for you to comb your hair? (உங்கள் தலைமுடியை சீவுவதில் கடினமாக இருக்கிறதா?)'),
    Question(
        '13. Is it difficult for you to reach a high shelf? (உயரமான அலமாரியை அடைவது உங்களுக்கு கடினமாக உள்ளதா?)'),
    Question(
        '14. Is it difficult for you to lift 10lbs (4.5kgs) above your shoulder? (உங்கள் தோளுக்கு மேலே 10 பவுண்டுகள் (4.5 கிலோ) தூக்குவது உங்களுக்கு கடினமாக உள்ளதா?)'),
    Question(
        '15. Is it difficult for you to throw a ball overhand? (நீங்கள் ஒரு பந்தை மேல்நோக்கி வீசுவது கடினமா?)'),
    Question(
        '16. Is it difficult for you to do your usual work?(உங்கள் வழக்கமான வேலையைச் செய்வது உங்களுக்கு கடினமாக இருக்கிறதா?)'),
    Question(
        '17. Is it difficult for you to do your usual sport /leisure activity? (உங்கள் வழக்கமான விளையாட்டு/ஓய்வுச் செயல்பாடுகளைச் செய்வது உங்களுக்கு கடினமாக உள்ளதா?)'),
  ];

  List<int?> _selectedChoices = List.filled(10, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0xFF0DA7A7),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Container(
                color: Color(0xFFD9D9D9),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        'American Shoulder and Elbow Surgeons Score (ASES)',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                    Text(
                      'A.Pain Questionnaire',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      '1. Usual work (வழக்கமான வேலை)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller:
                      usualWorkController, // Assign the TextEditingController
                      decoration: InputDecoration(
                        border:
                        OutlineInputBorder(), // Add border for visual clarity
                        filled: true,
                        fillColor: Colors.grey[200], // Background color
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '2. Usual Sport/leisure activity\n(வழக்கமான விளையாட்டு/ஓய்வுச் செயல்பாடு)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller:
                      usualSportController, // Assign the TextEditingController
                      decoration: InputDecoration(
                        border:
                        OutlineInputBorder(), // Add border for visual clarity
                        filled: true,
                        fillColor: Colors.grey[200], // Background color
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '3. Do you have shoulder pain at night ?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 'Yes',
                          groupValue: painAtNight,
                          onChanged: (value) {
                            setState(() {
                              painAtNight = value!;
                            });
                          },
                        ),
                        Text('Yes'),
                        SizedBox(width: 20),
                        Radio(
                          value: 'No',
                          groupValue: painAtNight,
                          onChanged: (value) {
                            setState(() {
                              painAtNight = value!;
                            });
                          },
                        ),
                        Text('No'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '4. Do you take pain killers such as paracetamol (acetaminophen), diclofenac or ibuprofen?\n(நீங்கள் பாராசிட்டமால்(அசெட்டமினோஃபென்),டிக்ளோஃபெனாக் அல்லது இப்யூபுரூஃபன் போன்ற வலி நிவாரணிகளை எடுத்துக்கொள்கிறீர்களா?) ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 'Yes',
                          groupValue: painKiller1,
                          onChanged: (value) {
                            setState(() {
                              painKiller1 = value!;
                            });
                          },
                        ),
                        Text('Yes'),
                        SizedBox(width: 20),
                        Radio(
                          value: 'No',
                          groupValue: painKiller1,
                          onChanged: (value) {
                            setState(() {
                              painKiller1 = value!;
                            });
                          },
                        ),
                        Text('No'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '5. Do you take strong pain killers such as codeine, Tramadol or morphine?\n (நீங்கள் கோடீன், டிராமடோல் அல்லது மார்பின் போன்ற வலிமையான வலி நிவாரணிகளை எடுத்துக்கொள்கிறீர்களா?)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 'Yes',
                          groupValue: painKiller2,
                          onChanged: (value) {
                            setState(() {
                              painKiller2 = value!;
                            });
                          },
                        ),
                        Text('Yes'),
                        SizedBox(width: 20),
                        Radio(
                          value: 'No',
                          groupValue: painKiller2,
                          onChanged: (value) {
                            setState(() {
                              painKiller2 = value!;
                            });
                          },
                        ),
                        Text('No'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '6. How many pills do you take on an average day? (சராசரியாக ஒரு நாளைக்கு எத்தனை மாத்திரைகள் எடுத்துக்கொள்கிறீர்கள்?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 'Yes',
                          groupValue: pills,
                          onChanged: (value) {
                            setState(() {
                              pills = value!;
                            });
                          },
                        ),
                        Text('Yes'),
                        SizedBox(width: 20),
                        Radio(
                          value: 'No',
                          groupValue: pills,
                          onChanged: (value) {
                            setState(() {
                              pills = value!;
                            });
                          },
                        ),
                        Text('No'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '7.Intensity of pain (value from 0-10) (வலியின் தீவிரம் (மதிப்பு 0-10 இலிருந்து ) -0-10',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Slider(
                      value: _sliderValue,
                      min: 0,
                      max: 10,
                      divisions: 10,
                      onChanged: (double newValue) {
                        setState(() {
                          _sliderValue = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Text(
                      'B. Activities of Daily Living Questionnaire',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Column(
                      children: List.generate(
                        _questions.length,
                            (index) => QuestionCard(
                          question: _questions[index],
                          selectedChoice: _selectedChoices[index],
                          onChoiceSelected: (choiceIndex) {
                            setState(() {
                              _selectedChoices[index] = choiceIndex;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    FloatingActionButton(
                      onPressed: () async {

                        try {


                          // Save patient details with photo URL to Firestore
                          String pid = widget.pid;
                          await _firestore.collection('patients').doc(pid).update({
                            'ASES':_calculateTotalScore().toString(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Patient details saved successfully')),
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => PatientHomeScreen(pid: pid)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to save patient details'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }




                        int totalScore = _calculateTotalScore();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Quiz Result'),
                              content: Text('Your total score is: $totalScore'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.check),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _calculateTotalScore() {
    int totalScore = 0;
    for (int? choice in _selectedChoices) {
      if (choice != null) {
        totalScore += choice;
      }
    }
    return totalScore;
  }
}

class Question {
  final String questionText;

  Question(this.questionText);
}

class QuestionCard extends StatelessWidget {
  final Question question;
  final int? selectedChoice;
  final ValueChanged<int?> onChoiceSelected;

  QuestionCard({
    required this.question,
    required this.selectedChoice,
    required this.onChoiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                4,
                    (index) => RadioListTile<int>(
                  title: Text(getChoiceText(index)),
                  value: index,
                  groupValue: selectedChoice,
                  onChanged: (value) {
                    onChoiceSelected(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getChoiceText(int index) {
    switch (index) {
      case 0:
        return 'Not difficult (0)';
      case 1:
        return 'Somewhat difficult (1)';
      case 2:
        return 'Very difficult (2)';
      case 3:
        return 'Unable to do (3)';
      default:
        return '';
    }
  }
}