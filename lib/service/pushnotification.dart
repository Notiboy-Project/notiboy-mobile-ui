import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notiboy/main.dart';
import 'package:notiboy/screen/home/chat/messages_screens.dart';
import 'package:notiboy/screen/home/notification/notification_screen.dart';
import 'package:provider/provider.dart';

import '../Model/notification/NotificationReadingModel.dart';
import '../constant.dart';
import 'notifier.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();
  bool isFlutterLocalNotificationsInitialized = false;
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String userB = '';

  Future<void> init() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestSoundPermission: true,
            defaultPresentSound: true,
            defaultPresentAlert: true,
            defaultPresentBanner: true,
            requestAlertPermission: true,
            requestProvisionalPermission: true,
            requestCriticalPermission: true,
          )),
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (details) {
        BottomNavigationBar navigationBar =
            bottomWidgetKey.currentWidget as BottomNavigationBar;
        navigationBar.onTap!(0);
      },
    );

    getInitMessages();

    isFlutterLocalNotificationsInitialized = true;
  }

  getInitMessages() {
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      if (message.data.containsKey('sender')) {
        if (message.data['sender'].toString().isNotEmpty)
          userB = message.data['sender'];
        BottomNavigationBar navigationBar =
            bottomWidgetKey.currentWidget as BottomNavigationBar;
        navigationBar.onTap!(1);
        // navigatorKey?.currentState?.push(MaterialPageRoute(
        //   builder: (context) => MessagesListScreen(userId: userB),
        // ));
        return;
      }
      BottomNavigationBar navigationBar =
          bottomWidgetKey.currentWidget as BottomNavigationBar;
      navigationBar.onTap!(0);
    });
  }

  void showFlutterNotification(RemoteMessage message) {
    BottomNavigationBar navigationBar =
        bottomWidgetKey.currentWidget as BottomNavigationBar;

    if (navigationBar.currentIndex == 1 &&
        Provider.of<MyChangeNotifier>(navigatorKey!.currentState!.context,
                listen: false)
            .isUserInMessagingScreen) {
      return;
    }
    if (message.data['sender'].toString().isNotEmpty)
      userB = message.data['sender'];
    Map<String, dynamic> notification = message.data;
    if (!kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        NotificationDetails(
          iOS: DarwinNotificationDetails(
            interruptionLevel: InterruptionLevel.active,
            presentAlert: true,
            presentSound: true,
            presentBanner: true,
          ),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }
}
