import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GraphsDr extends StatefulWidget {
  final String pid;
  const GraphsDr({Key? key, required this.pid}) : super(key: key);

  @override
  State<GraphsDr> createState() => _GraphsDrState();
}

class _GraphsDrState extends State<GraphsDr> {
  double woundStatusProgress = 0.0;
  double rangeOfMovementsProgress = 0.0;
  double flexionProgress = 0.0;
  double extensionProgress = 0.0;
  double internalRotationProgress = 0.0;
  double externalRotationProgress = 0.0;
  double pronationProgress = 0.0;
  double supinationProgress = 0.0;

  @override
  void initState() {
    super.initState();
    addReviewDataToFirestore();
  }

  Future<void> addReviewDataToFirestore() async {
    try {
      String pid = widget.pid;

      // Get the document snapshot
      DocumentSnapshot reviewSnapshot = await FirebaseFirestore.instance.collection('reviews').doc(pid).get();

      // Get individual arrays from the document snapshot
      List<dynamic> woundStatusList = reviewSnapshot['woundStatus'] ?? [];
      List<dynamic> rangeOfMovementsList = reviewSnapshot['rangeOfMovements'] ?? [];
      List<dynamic> flexionList = reviewSnapshot['flexion'] ?? [];
      List<dynamic> extensionList = reviewSnapshot['extension'] ?? [];
      List<dynamic> internalRotationList = reviewSnapshot['internalRotation'] ?? [];
      List<dynamic> externalRotationList = reviewSnapshot['externalRotation'] ?? [];
      List<dynamic> pronationList = reviewSnapshot['pronation'] ?? [];
      List<dynamic> supinationList = reviewSnapshot['supination'] ?? [];

      // Calculate the average of each array and scale to 100
      woundStatusProgress = _calculateAverage(woundStatusList);
      rangeOfMovementsProgress = _calculateAverage(rangeOfMovementsList) ;
      flexionProgress = _calculateAverage(flexionList) ;
      extensionProgress = _calculateAverage(extensionList) ;
      internalRotationProgress = _calculateAverage(internalRotationList);
      externalRotationProgress = _calculateAverage(externalRotationList) ;
      pronationProgress = _calculateAverage(pronationList) ;
      supinationProgress = _calculateAverage(supinationList) ;

      print('Averages calculated and progress bars updated successfully');
      setState(() {}); // Update the UI with the new progress values
    } catch (e) {
      print('Error updating review data: $e');
    }
  }

  double _calculateAverage(List<dynamic> list) {
    if (list.isEmpty) {
      return 0.0;
    } else {
      double sum = 0;
      for (dynamic value in list) {
        sum += double.parse(value.toString());
      }
      return sum / list.length;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Spacer(),
                _buildProgressBar("Wound Status", woundStatusProgress, Colors.blue),
                Spacer(),
                _buildProgressBar("Range of Movements", rangeOfMovementsProgress, Colors.green),
                Spacer()
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Spacer(),
                _buildProgressBar("Flexion", flexionProgress, Colors.red),
                Spacer(),
                _buildProgressBar("Extension", extensionProgress, Colors.orange),
                Spacer()
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                _buildProgressBar("Internal Rotation", internalRotationProgress, Colors.pink),
                Spacer(),
                _buildProgressBar("External Rotation", externalRotationProgress, Colors.purple),
                Spacer()
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                _buildProgressBar("Pronation", pronationProgress, Colors.teal),
                Spacer(),
                _buildProgressBar("Supination", supinationProgress, Colors.yellow),
                Spacer()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String name, double value, Color color) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                strokeWidth: 12,
                value: value / 100,
                backgroundColor: Colors.grey[300],
                color: color,
              ),
              Center(
                child: Text(
                  '${value.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
