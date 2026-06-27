

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../my_app.dart';

class FlutterLocalNotification {

  /// Singleton
  FlutterLocalNotification._();
  static FlutterLocalNotification get instance => FlutterLocalNotification._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{

    // get settings
    final settings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'));

    // initialize local notification
    _notificationsPlugin.initialize(settings: settings, onDidReceiveNotificationResponse: _onNotificationTap);

    final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    // request permission
    androidPlugin?.requestNotificationsPermission();

  }

  void _onNotificationTap(NotificationResponse response) {
    final data = jsonDecode(response.payload ?? '');
    String screen = data['screen'];
    if(screen.isNotEmpty){
      navigatorKey.currentState?.pushNamed('/$screen');
    }
  }

  void showNotification(String title, String body, Map<String, dynamic> data){

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('channel', 'Channel')
    );

    _notificationsPlugin.show(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(data)
    );

  }


}