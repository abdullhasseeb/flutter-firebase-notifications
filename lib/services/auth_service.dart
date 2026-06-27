import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_notifications/services/user_service.dart';

class AuthService {

  /// Singleton
  AuthService._();
  static AuthService get instance => AuthService._();

  final _auth = FirebaseAuth.instance;

  Future<String?> signUp(String name, String email, String password) async{
    try{

      // create account
      final credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // update name
      credentials.user?.updateDisplayName(name);

      await UserService.instance.saveUser();

      return null;
    }catch(e){
      print('Error while sign up: $e');
      return 'Something went wrong';
    }
  }


  Future<String?> signIn(String email, String password) async {
    try {
      // sign the user in
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // refresh / save token for this device after login
      await UserService.instance.saveUser();

      // null means success
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      print('Error while sign in: $e');
      return 'Something went wrong';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}