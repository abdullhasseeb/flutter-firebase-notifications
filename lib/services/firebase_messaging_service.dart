

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_notifications/my_app.dart';
import 'package:flutter_notifications/services/flutter_local_notification.dart';

class FirebaseMessagingService {

  /// Singleton
  FirebaseMessagingService._();
  static FirebaseMessagingService get instance => FirebaseMessagingService._();


  /// Function to initialize all notification services
  Future<void> initialize() async{
    initializeNotificationListener();
    initializeInitialMessage();
    initializeOnAppOpenedNotification();
  }

  /// Function to initialize notification listener while app is opened
  Future<void> initializeNotificationListener() async{
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      if(remoteMessage.notification == null) {
        print('Notification is null');
        return;
      }

      String title = remoteMessage.notification?.title ?? '';
      String body = remoteMessage.notification?.body ?? '';
      Map<String, dynamic> data = remoteMessage.data ?? {};

      FlutterLocalNotification.instance.showNotification(title, body, data);
    });
  }

  /// [InitialMessage] - Function to get initial message when app is opened by clicking on notification
  Future<void> initializeInitialMessage() async{
    RemoteMessage? message =  await FirebaseMessaging.instance.getInitialMessage();
    if(message == null) return;

    String screen = message.data['screen'] ?? '';
    if(screen.isNotEmpty){
      navigatorKey.currentState?.pushNamed('/$screen');
    }
  }

  /// [InitializeAppOpened] - Show Notification When opened app, save in local and reload the notifications
  Future<void> initializeOnAppOpenedNotification()  async{
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) async{
      String screen = remoteMessage.data['screen'] ?? '';
      if(screen.isNotEmpty){
        navigatorKey.currentState?.pushNamed('/$screen');
      }
    });
  }
}