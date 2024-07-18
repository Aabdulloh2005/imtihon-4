class User {
  final String id;
  final String uid;
  final String token;
  final String userName;
  final String email;
  final String photoUrl;
  final List<String> favoriteEventsId;
  final List<String> registeredEventsId;
  final List<String> participatedEvents;
  final List<String> canceledEvents;

  const User({
    required this.id,
    required this.uid,
    required this.token,
    required this.userName,
    required this.email,
    required this.photoUrl,
    required this.favoriteEventsId,
    required this.registeredEventsId,
    required this.participatedEvents,
    required this.canceledEvents,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uid: json['uid'],
      token: json['token'],
      userName: json['userName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      favoriteEventsId: (json['favoriteEvents'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      registeredEventsId: (json['registeredEvents'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      participatedEvents: (json['participatedEvents'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      canceledEvents: (json['canceledEvents'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }
}
