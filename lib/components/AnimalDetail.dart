import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/PetSession.dart';
import '../data/pricepoint.dart';
import 'AnimalList.dart';
import 'BarChart.dart';

class AnimalDetail extends StatefulWidget {
  final AnimalData animalData;

  const AnimalDetail({Key? key, required this.animalData}) : super(key: key);

  @override
  _AnimalDetailState createState() => _AnimalDetailState();
}

class _AnimalDetailState extends State<AnimalDetail> {
  String calculateDuration(DateTime startTime, DateTime endTime) {
    Duration difference = endTime.difference(startTime);
    int minutes = difference.inMinutes;
    return '$minutes Minuten';
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  late FirebaseFirestore db;
  late PetSession lastSession;

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
    lastSession = PetSession(
      duration: const Duration(minutes: 0), // Initialize with default values
      tagId: '',
      created: Timestamp.now(),
      start: Timestamp.now(),
      end: Timestamp.now(),
      formattedDuration: '',
    );
    _fetchLatestSession();
  }

  Future<void> _fetchLatestSession() async {
    var queryResult = await db
        .collection("sessions")
        .where("tagId", isEqualTo: widget.animalData.tagId)
        .orderBy("created", descending: true)
        .limit(1)
        .get();

    if (queryResult.docs.isNotEmpty) {
      setState(() {
        lastSession = PetSession.fromJson(queryResult.docs[0].data());
      });
    } else {
      setState(() {
        lastSession = PetSession(
          duration: const Duration(minutes: 34),
          tagId: widget.animalData.tagId,
          created: Timestamp.fromDate(widget.animalData.petStartTime),
          start: Timestamp.fromDate(widget.animalData.petStartTime),
          end: Timestamp.fromDate(widget.animalData.petEndTime),
          formattedDuration: calculateDuration(
              widget.animalData.petStartTime, widget.animalData.petEndTime),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              backgroundImage:
                  NetworkImage(widget.animalData.profilePictureUrl),
            ),
            const SizedBox(height: 8),
            Text(
              "${widget.animalData.name} #${widget.animalData.tagId}",
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
                            .format(lastSession.created.toDate())),
                    _buildTableRow('Dauer:', lastSession.formattedDuration),
                    _buildTableRow(
                        'Start:', formatDate(lastSession.start.toDate())),
                    _buildTableRow(
                        'Ende:', formatDate(lastSession.end.toDate())),
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
