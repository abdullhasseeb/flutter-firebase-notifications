
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:googleapis_auth/auth_io.dart' as auth1;
class NotificationService {

  NotificationService._();
  static NotificationService get instance => NotificationService._();

  final String _projectId = '';
  /// scope required to send messages through fcm v1 api
  static const List<String> scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  Future<void> sendNotification({
    required String targetFcmToken,
    required String title,
    required String subtitle,
    Map<String, dynamic> data = const {}
}) async{


   try{
     final serviceAccount = await rootBundle.loadString('');

     final credentials = auth.ServiceAccountCredentials.fromJson(serviceAccount);
     final client = await auth1.clientViaServiceAccount(credentials, scopes);

     final url = Uri.parse('https://fcm.googleapis.com/v1/projects/$_projectId/messages:send');


     // build the fcm v1 message body
     final body = {
       'message': {
         'token': targetFcmToken,
         'notification': {'title': title, 'body': subtitle},
         'data': data,
       },
     };

     final response = await client.post(url, body: jsonEncode(body));

     if (response.statusCode != 200) {
       print('FCM send failed: ${response.body}');
     }


     client.close();
   }catch(e){
     print('Error when send notification : $e');
   }
  }
}