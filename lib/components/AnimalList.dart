import 'package:flutter/material.dart';

import 'AnimalDetail.dart';

var start1 = DateTime.now().subtract(const Duration(days: 2));
var start2 = DateTime.now().subtract(const Duration(days: 15));
var start3 = DateTime.now().subtract(const Duration(days: 7));

class AnimalList extends StatelessWidget {
  final List<AnimalData> animals = [
    AnimalData(
      tagId: "6262",
      name: 'Felix',
      profilePictureUrl:
          'https://i.pinimg.com/736x/5d/22/cb/5d22cbbaf3cd689020ad795f14092cd3.jpg',
      lastPetTime: start2,
      petStartTime: start2.subtract(const Duration(minutes: 23)),
      petEndTime: start2,
    ),
    AnimalData(
      tagId: "55555",
      name: 'Luna',
      profilePictureUrl:
          'https://www.thetimes.co.uk/imageserver/image/%2Fmethode%2Ftimes%2Fprod%2Fweb%2Fbin%2F84e03f68-eef8-11eb-a2a3-afea84050239.jpg?crop=4246%2C2388%2C0%2C221&resize=1200',
      lastPetTime: start3,
      petStartTime: start3.subtract(const Duration(minutes: 34)),
      petEndTime: start3,
    ),
    AnimalData(
      tagId: "1111",
      name: 'Mia',
      profilePictureUrl:
          'https://hips.hearstapps.com/hmg-prod/images/large-cat-breed-1553197454.jpg',
      lastPetTime: start1,
      petStartTime: start1.subtract(const Duration(minutes: 15)),
      petEndTime: start1,
    ),
    // Add more animal data here
  ];

  AnimalList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Tiere'),
      ),
      body: ListView.builder(
        itemCount: animals.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimalDetail(
                    animalData: animals[index],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ), // Adjust padding
              decoration: BoxDecoration(
                color:
                    Colors.grey.shade50, // Background color of each list tile
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow offset
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30, // Increase the radius of CircleAvatar
                  backgroundImage:
                      NetworkImage(animals[index].profilePictureUrl),
                ),
                title: Text(animals[index].name),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimalData {
  final String name;
  final String profilePictureUrl;
  final DateTime lastPetTime;
  final DateTime petStartTime;
  final DateTime petEndTime;
  final String tagId;

  AnimalData({
    required this.tagId,
    required this.name,
    required this.profilePictureUrl,
    required this.lastPetTime,
    required this.petStartTime,
    required this.petEndTime,
  });
}

void main() {
  runApp(MaterialApp(
    home: AnimalList(),
  ));
}
