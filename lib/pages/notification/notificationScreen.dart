import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static const route = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    final RemoteMessage message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    final notification = message.notification;
    final title = notification?.title ?? 'No title';
    final body = notification?.body ?? 'No body';

    final data = message.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: $title'),
            Text('Body: $body'),
            Text('Payload: $data'),
          ],
        ),
      ),
    );
  }
}
