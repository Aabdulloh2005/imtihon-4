import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/services/tadbir_service_firebase.dart';

class TadbirRepository {
  final TadbirServiceFirebase tadbirServiceFirebase;

  TadbirRepository({
    required this.tadbirServiceFirebase,
  });

  Stream<QuerySnapshot> fetchEvents() async* {
    yield* tadbirServiceFirebase.fetchEvents();
  }

  Stream<QuerySnapshot> fetchMyEvents() async* {
    yield* tadbirServiceFirebase.fetchMyEvents();
  }

  void addEvent(Event event) async {
    await tadbirServiceFirebase.addEvent(event);
  }
}
