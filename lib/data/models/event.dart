import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? id;
  final String creatorId;
  final String creatorName;
  final String creatorImageUrl;
  final String name;
  final Timestamp startTime;
  final GeoPoint geoPoint;
  final String description;
  final String imageUrl;
  final String locationName;
  final int personCount;

  Event({
    this.id,
    required this.creatorId,
    required this.creatorName,
    required this.creatorImageUrl,
    required this.name,
    required this.startTime,
    required this.geoPoint,
    required this.description,
    required this.imageUrl,
    required this.locationName,
    required this.personCount,
  });

  factory Event.fromQuerySnapshot(QueryDocumentSnapshot query) {
    return Event(
      id: query.id,
      creatorId: query['creatorId'],
      creatorName: query['creatorName'],
      creatorImageUrl: query['creatorImageUrl'],
      name: query['name'],
      startTime: query['startTime'],
      geoPoint: query['geoPoint'],
      description: query['description'],
      imageUrl: query['imageUrl'],
      locationName: query['locationName'],
      personCount: query['personCount'],
    );
  }
}
