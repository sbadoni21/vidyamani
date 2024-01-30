import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    print("=======>requestNotificationPermission");
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User Granted Provisional permission");
    } else {
      print("User Denied permission");
    }
  }

  void initialize(BuildContext context) {
    print("Initialize Notification");
    requestNotificationPermission();

    isTokenRefreshed();

    getDeviceToken().then((value) {
      print("Device Token");
      print(value);
    });
    _requestIOSPermissions();
    _configureListeners(context);
  }

  void _requestIOSPermissions() {
    print("Requesting Permission iOS");
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureListeners(BuildContext context) {
    print("==============ConfigureListeners");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("==========onMessage");
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
      initLocalNotifications(context, message);
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("onMessageOpenedApp");
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
      handleMessage(context, message);
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        print("getInitialMessage: $message");
        handleMessage(context, message);
      }
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token!;
  }

  void isTokenRefreshed() async {
    _firebaseMessaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    print("==========initLocalNotifications");
    var androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitializationSettings = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iOSInitializationSettings);

    await _flutterNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {

    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
            Random.secure().nextInt(100000).toString(), "Vidhyamani",
            importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidNotificationChannel.id.toString(),
            androidNotificationChannel.name.toString(),
            channelDescription: "Vidhyamani channel",
            importance: Importance.high,
            priority: Priority.high,
            ticker: "ticker");
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterNotificationPlugin.show(0, message.notification!.title.toString(),
          message.notification!.body.toString(), notificationDetails);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {

    if (message!= null) {
      
    }
  }
}