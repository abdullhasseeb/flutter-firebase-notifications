import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/services/firebase_messaging_service.dart';
import 'package:flutter_notifications/services/flutter_local_notification.dart';

// import 'firebase_options.dart';
import 'my_app.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundHandler(RemoteMessage message) async{
  try{
    /// Initialize Flutter Binding
    WidgetsFlutterBinding.ensureInitialized();

    /// Firebase Connection
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }catch(e){
    print('Error in background handler : $e');
  }
}



void main() async{

  /// Initialize Flutter Binding
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase Connection
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Handle Background Message
  FirebaseMessaging.onBackgroundMessage(onBackgroundHandler);

  /// Initialize Flutter Local Notifications
  FlutterLocalNotification.instance.initialize();

  /// Initialize Firebase Messaging Service
  FirebaseMessagingService.instance.initialize();

  runApp(const MyApp());
}



