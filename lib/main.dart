import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/ui/screens.dart';
import 'package:todo_app/util/utils.dart';

Future<void> main() async {
  await NotificationController.init();
  await AwesomeNotifications().requestPermissionToSendNotifications(
    channelKey: NotificationController.reminderNotificationKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: DepInit(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const Home(),
    );
  }
}
