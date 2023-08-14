import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/pricepoint.dart';
import 'AnimalList.dart';
import 'BarChart.dart';

String calculateDuration(DateTime startTime, DateTime endTime) {
  Duration difference = endTime.difference(startTime);
  int minutes = difference.inMinutes;
  return '$minutes Minuten';
}

void getLatestSession(String tagId, FirebaseFirestore db) {
  db.collection("sessions").where("tagId", isEqualTo: tagId).orderBy("created",descending: true).limit(1).get().then(
        (querySnapshot) {
      print("Got latest document for: $tagId");
      for (var docSnapshot in querySnapshot.docs) {
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    },
    onError: (e) => print("Error completing: $e"),
  );
}

class AnimalDetail extends StatelessWidget {
  final AnimalData animalData;
  final String petDuration;
  final db = FirebaseFirestore.instance;

  AnimalDetail({super.key, required this.animalData})
      : petDuration =
  calculateDuration(animalData.petStartTime, animalData.petEndTime);

  String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }



  LineChartData data = LineChartData(
    lineBarsData: [
      LineChartBarData(
        spots: pricePoints.map((point) => FlSpot(point.x, point.y)).toList(),
        isCurved: false,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    var data = getLatestSession(animalData.tagId, db);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tier Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(animalData.profilePictureUrl),
            ),
            const SizedBox(height: 8),
            Text(
              animalData.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Letzte Streicheleinheit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(
                        0.4), // Adjust the width ratio between label and value
                  },
                  children: [
                    _buildTableRow(
                        'Datum:',
                        DateFormat('dd.MM.yyyy')
                            .format(animalData.lastPetTime)),
                    _buildTableRow('Dauer:', petDuration),
                    _buildTableRow(
                        'Start:', formatDate(animalData.petStartTime)),
                    _buildTableRow('Ende:', formatDate(animalData.petEndTime)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Streichel Statistiken',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 2,
                child: BarChartWidget(points: pricePoints),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }


}
