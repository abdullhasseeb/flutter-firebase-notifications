

import 'package:flutter/material.dart';
import 'package:flutter_notifications/screens/send_notification_screen.dart';
import 'package:flutter_notifications/services/user_service.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _userService = UserService.instance;

  @override
  void initState() {
    _userService.saveUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// AppBar
      appBar: AppBar(
        title: const Text('Select User'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService.instance.signOut(),
          ),
        ],
      ),

      /// Body
      body: StreamBuilder(
          stream: _userService.getUsers(),
          builder: (context, snapshot) {

            /// [State] - Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            /// [State] - Error
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            List<UserModel> users = snapshot.data ?? [];

            /// [State] - Empty
            if(users.isEmpty){
              return Center(child: Text('No other users found'));
            }

            return ListView.builder(
              itemCount: users.length,
                itemBuilder: (context, index) {
                  UserModel user = users[index];

                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SendNotificationScreen(user: user)));
                    },
                  );
                },
            );

          },
      ),
    );
  }
}
