import 'package:flutter/material.dart';


// Libraries
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void clearNotification()
{
	FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

	flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
	var android = new AndroidInitializationSettings('icon_notifications_gray');
	var ios = new IOSInitializationSettings();
	var initSettings = new InitializationSettings(android, ios);

	flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

	flutterLocalNotificationsPlugin.cancelAll();
}

Future onSelectNotification(String payload) async
{
	debugPrint("payload: $payload");
}