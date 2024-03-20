import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';

class ForegroundNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void _initLocalNotifications(RemoteMessage message) async {
    var androidInitilizationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitilizationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      _handleMessage(payload, message);
    });
  }

  void firebaseInit() {
    FirebaseMessaging.instance.subscribeToTopic('images_completed');

    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print("notification title ${notification!.title}");
        print("notification body ${notification.body}");
      }
      if (Platform.isIOS) {
        _foregroundMessage();
      }
      if (Platform.isAndroid) {
        _initLocalNotifications(message);
        _showNotification(message);
      }
    });
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    String permissionStatus;
    switch (settings.authorizationStatus) {
      case AuthorizationStatus.authorized:
        permissionStatus = 'user granted permission';
        break;
      case AuthorizationStatus.provisional:
        permissionStatus = 'user granted provisional permission';
        break;
      default:
        permissionStatus = 'user denied permission';
        break;
    }

    if (kDebugMode) {
      print(permissionStatus);
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
      showBadge: true,
      playSound: true,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker',
            sound: channel.sound
            //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
            //  icon: largeIconPath
            );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    var ext = '';

    for (MapEntry<String, dynamic> item in message.data.entries) {
      ext += item.value as String;
      ext += '|';
    }
    if (kDebugMode) {
      print('values $ext');
    }

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title.toString(),
          message.notification?.body.toString(),
          notificationDetails,
          payload: ext);
    });
  }

  void _handleMessage(NotificationResponse payload, RemoteMessage message) {
    //Do something in the app when the notification is tapped
    if (kDebugMode) {
      print(
          'handlemesage: ${message.messageId.toString()} Payload: ${payload.payload}');
    }
  }

  Future _foregroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }
}
