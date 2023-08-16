import 'package:cloud_firestore/cloud_firestore.dart';

class PetSession {
  Duration duration;
  String tagId;
  Timestamp created;
  Timestamp start;
  Timestamp end;
  String formattedDuration;


  PetSession({
    required this.duration,
    required this.tagId,
    required this.created,
    required this.start,
    required this.end,
    required this.formattedDuration,
  });

  factory PetSession.fromJson(Map<String, dynamic> json) {
    return PetSession(
      duration: Duration(
        hours: json['duration']['hours'],
        minutes: json['duration']['minutes'],
        seconds: json['duration']['seconds'],
      ),
      formattedDuration: json['duration']['formatted'],
      tagId: json['tagId'],
      created: json['created'],
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': {
        'hours': duration.inHours,
        'minutes': duration.inMinutes.remainder(60),
        'seconds': duration.inSeconds.remainder(60),
        'formatted': duration.toString(),
      },
      'tagId': tagId,
      'created': created,
      'start': start,
      'end': end,
    };
  }
}
