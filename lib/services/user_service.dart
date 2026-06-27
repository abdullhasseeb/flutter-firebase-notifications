

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/user_model.dart';

class UserService {


  /// Singleton
  UserService._();
  static UserService get instance => UserService._();

  final _firestore = FirebaseFirestore.instance;


  /// Save user record
  Future<void> saveUser() async{
    try{
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) return;

      final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

      await _firestore.collection('Users').doc(user.uid).set({
        'uid' : user.uid,
        'name': user.displayName ?? 'Not Found',
        'email': user.email,
        'fcmToken': fcmToken,
      }, SetOptions(merge: true));


      FirebaseMessaging.instance.onTokenRefresh.listen((newFcmToken) {
        _firestore.collection('Users').doc(user.uid).update({'fcmToken' : newFcmToken});
      },);
    }catch(e){
      print('Error when save user : $e');
    }
  }

  /// Get all users of the app
  Stream<List<UserModel>> getUsers() {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) => doc.id != currentUid)
          .map((doc) => UserModel.fromMap(doc.data()))
          .toList();
    });

  }

}
