import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controllers/controllers.dart';
import 'package:todo_app/ui/widgets/widget.dart';
import 'package:todo_app/util/utils.dart';

class NotificationController {
  NotificationController._();

  static const String reminderNotificationKey = "reminder_notification";

  static final List<NotificationChannel> notificationChannel = [
    NotificationChannel(
      channelKey: reminderNotificationKey,
      channelName: "Task Reminder",
      channelDescription: "Task Reminder Notifiations",
      importance: NotificationImportance.Max,
      ledColor: Colors.teal,
      enableLights: true,
      playSound: true,
    ),
  ];

  static Future<void> init() async {
    await AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      notificationChannel,
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    "notification created".log();
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    "notification displayed".log();
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    "notification dismiss".log();
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    final controller = Get.find<TaskController>();
    final taskId = int.parse(receivedAction.payload!['taskId']!);
    final task = await controller.getTask(taskId);
    if (task != null) {
      Get.dialog(AlertDialog(
        content: TaskDetail(task: task),
      ));
    }
  }
}
