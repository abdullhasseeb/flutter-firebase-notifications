import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notifications/screens/chat_screen.dart';
import 'package:flutter_notifications/screens/home_screen.dart';
import 'package:flutter_notifications/screens/login_screen.dart';
import 'package:flutter_notifications/screens/profile_screen.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: AuthGate(),
      routes: {
        '/profile' : (context) => ProfileScreen(),
        '/chat_detail' : (context) => ChatScreen()
      },
    );
  }
}


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          /// [State] - Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          /// [State] - User Found
          if (snapshot.hasData) {
            return const HomeScreen();
          }

          /// [State] - User not found
          return const LoginScreen();
        },
    );
  }
}
