import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class FirebasePushNotificationService {
  static final _pushNotification = FirebaseMessaging.instance;

  static Future<String?> getToken() async {

    final token = await _pushNotification.getToken();
    return token;
  }

  static Future<void> init() async {
    final notificationSettings = await _pushNotification.requestPermission();

  
  }

  static void sendNotificationMessage(
      String token, String fromUSer, String message) async {
    await Future.delayed(Duration(seconds: 2));
    final jsonCredentials = await rootBundle.loadString('service-account.json');

    var accountCredentials =
        ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    // print(client.credentials.accessToken);
    final notificationData = {
      'message': {
        'token': token,
        'notification': {

          'title': fromUSer,
          'body': message,
        }
      },
    };

    const projectId = "telegram-chat-tg";
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      print("YUBORILDI");
    }

  }


  static void sendNotificationImage(
      String token, String fromUSer, String image) async {
    await Future.delayed(Duration(seconds: 2));
    final jsonCredentials = await rootBundle.loadString('service-account.json');

    var accountCredentials =
        ServiceAccountCredentials.fromJson(jsonCredentials);

    var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);

    // print(client.credentials.accessToken);
    final notificationData = {
      'message': {
        'token': token,
        'notification': {
          
          'title': fromUSer,
          'image': image,
        }
      },
    };

    const projectId = "telegram-chat-tg";
    Uri url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");

    final response = await client.post(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer ${client.credentials.accessToken}',
      },
      body: jsonEncode(notificationData),
    );

    client.close();
    if (response.statusCode == 200) {
      print("YUBORILDI");
    }

  }

}