import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tadbiro_app/data/models/event.dart';

class TadbirServiceFirebase {
  final firebaseservice = FirebaseFirestore.instance.collection('events');
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Stream<QuerySnapshot> fetchEvents() async* {
    yield* firebaseservice.where("creatorId", isNotEqualTo: userId).snapshots();
  }

  Stream<QuerySnapshot> fetchMyEvents() async* {
    yield* firebaseservice.where("creatorId", isEqualTo: userId).snapshots();
  }

  Stream<QuerySnapshot> fetchRecentEvents() async* {
    final Timestamp now = Timestamp.now();
    final Timestamp nextWeek = Timestamp.fromDate(DateTime.now().add(
      const Duration(days: 7),
    ));

    yield* firebaseservice
        .where('startTime', isGreaterThanOrEqualTo: now)
        .where('startTime', isLessThanOrEqualTo: nextWeek)
        .snapshots();
  }

  Future<void> addEvent(Event event) async {
    await firebaseservice.add({
      "locationName": event.locationName,
      "creatorName": event.creatorName,
      "creatorImageUrl": event.creatorImageUrl,
      "creatorId": event.creatorId,
      "name": event.name,
      "startTime": event.startTime,
      "geoPoint": event.geoPoint,
      "description": event.description,
      "imageUrl": event.imageUrl,
      'personCount': event.personCount,
    });
  }

  Future<void> updateEvent(String id, int count) async {
    await firebaseservice.doc(id).update(
      {
        'personCount': count,
      },
    );
  }
}
