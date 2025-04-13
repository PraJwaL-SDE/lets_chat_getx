import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:lest_chat_5/app/data/models/message_model.dart';


import 'GetServerKey.dart';

class NotificationServices{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const _serviceAccountJson = {
    
  };

  static Future<String> getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(_serviceAccountJson);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(accountCredentials, scopes);
    return client.credentials.accessToken.data;
  }

  void sendNotificationToTarget(String targetToken, RemoteMessage message, MessageModel msgModel) async {
    final accessToken = await Getserverkey.getServerKeyToken();
    print("Access Token: $accessToken");
    print("Target device token: $targetToken");

    final data = {
      'message': {
        'token': targetToken,
        'notification': {
          'title': message.notification?.title ?? 'Default Title',
          'body': (msgModel.type == "text" || msgModel.type == "video_call" || msgModel.type == "audio_call")
              ? (message.notification?.body ?? 'Default Body')
              : (msgModel.type == "image"
              ? 'Image' 
              :   'Not a text message'),
          // Include an optional 'image' field if type is 'image'
          if (msgModel.type == "image") 'image': msgModel.text ?? 'Default Image URL',
        },
        'data': {
          'click_action':"FLUTTER_NOTIFICATION_CLICK",
          'type' : msgModel.type,
          'roomId': msgModel.id
        },
        'android': {
          'priority': 'high',  // Ensures notification is delivered promptly
          'notification': {

            // Optional image field for Android notifications
            if (msgModel.type == "image") 'image': msgModel.text ?? 'Default Image URL',

          },
        },
        'apns': {
          'payload': {
            'aps': {
              'content-available': 1,
              'alert': {
                'title': message.notification?.title ?? 'Default Title',
                'body': msgModel.type == "text"
                    ? (message.notification?.body ?? 'Default Body')
                    : (msgModel.type == "image"
                    ? 'Image URL' // Placeholder, 'body' is now the image URL or description
                    : 'Not a text message'
                    ),
              },
            },
          },
          'headers': {
            'apns-priority': '10',  // Ensures high priority delivery on iOS
          },
        },
      }
    };


    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/chatting-app-2-8e7d4/messages:send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('1234 ........................................Notification sent successfully');
    } else {
      print('1234 Failed to send notification: ${response.statusCode}');
      print(response.body);
    }
  }

  void requestNotificationPermission() async{
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){

    }else{

    }
  }

  void initLocalNotificationPlugin(BuildContext context , RemoteMessage message)async{
    try{
      var androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
      var initializationSettings = InitializationSettings(
          android: androidInitializationSettings,
          iOS: DarwinInitializationSettings()
      );
      // _flutterLocalNotificationsPlugin.initialize(
      //     initializationSettings,
      //     onDidReceiveNotificationResponse: (payload){
      //       print("................Notification click ");
      //       print(message.notification!.title);
      //       print(message.notification!.body);
      //       print(message.data);
      //       if(message.data["type"]=="video_call")
      //       Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallScreen(roomId: message.notification!.body!)));
      //
      //
      //     }
      // );
      print("...... initializationSettings");
    }catch(e){
      print("error in initLocalNotificationPlugin");
      print(e);
    }

  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      "1000",
      "default_notification",
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    final id = 100;
    await _flutterLocalNotificationsPlugin.show(
      id ?? 0,
      message.notification!.title ?? '',
      message.notification!.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: "Nothing",
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),

    );
    print("Notification Sent");
    _flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),

    );
  }

  void firebaseInit(BuildContext context) {

    FirebaseMessaging.onMessage.listen((message) {
      print("...........calling initLocalNotificationPlugin");
      initLocalNotificationPlugin(context, message);
      showNotification(message);

    });
  }

  Future<void> setupInteractMessage(BuildContext context)async{
    print(".........setupInteractMessage");
    // when app is terminated
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }


    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });

  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    print("Notification Click");
    // if(message.data['type'] =='video_call'){
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallScreen(roomId: message.data["roomId"])));
    // }
  }


   Future<String?> getDeviceToken() async{
    return await messaging.getToken();
  }

}

