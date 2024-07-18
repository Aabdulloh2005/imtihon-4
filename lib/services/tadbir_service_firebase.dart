import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro_app/data/models/event.dart';

class TadbirServiceFirebase {
  final firebaseservice = FirebaseFirestore.instance.collection('events');

  Stream<QuerySnapshot> fetchEvents() async* {
    yield* firebaseservice.snapshots();
  }

  Future<void> addEvent(Event event) async {
    await firebaseservice.add({
      "creatorId": event.creatorId,
      "name": event.name,
      "time": event.time,
      "geoPoint": event.geoPoint,
      "description": event.description,
      "imageUrl": event.imageUrl,
    });
  }
}
