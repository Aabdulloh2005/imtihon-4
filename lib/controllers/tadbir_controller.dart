import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/services/tadbir_service_firebase.dart';

class TadbirController extends ChangeNotifier {
  final TadbirServiceFirebase tadbirServiceFirebase;

  TadbirController({
    
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

  void updateEvent(String creatorId, int count) async {
    await tadbirServiceFirebase.updateEvent(creatorId, count);
  }
}
