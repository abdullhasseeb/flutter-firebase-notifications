


import 'package:flutter/material.dart';
import 'package:flutter_notifications/models/user_model.dart';
import 'package:flutter_notifications/services/notification_service.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({super.key, required this.user});

  final UserModel user;
  @override
  State<SendNotificationScreen> createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  // which screen should open on the receiver side when tapped
  String _selectedScreen = 'chat_detail';

  bool _isSending = false;

  /// [SendNotification] - Build data payload and send to the selected user
  Future<void> _sendNotification() async {
    setState(() => _isSending = true);

    final data  = {
      'screen' : _selectedScreen,
    };

    await NotificationService.instance.sendNotification(
        targetFcmToken: widget.user.fcmToken,
        title: _titleController.text,
        subtitle: _bodyController.text,
      data: data
    );

    setState(() => _isSending = false);

    // let user know it was sent
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification sent')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send to ${widget.user.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 12),

            TextField(controller: _bodyController, decoration: const InputDecoration(labelText: 'Body')),
            const SizedBox(height: 12),

            // pick which screen should open on tap
            DropdownButton<String>(
              value: _selectedScreen,
              items: const [
                DropdownMenuItem(value: 'chat_detail', child: Text('Chat Detail')),
                DropdownMenuItem(value: 'profile', child: Text('Profile')),
              ],
              onChanged: (value) => setState(() => _selectedScreen = value!),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isSending ? null : _sendNotification,
              child: _isSending
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
