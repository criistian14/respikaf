import 'package:flutter/material.dart';


// Libraries
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';


class CreateNotification 
{
	final context;
	final int hour, minute;
	final String name; 
	FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

	CreateNotification({ this.context, this.hour, this.minute, this.name })
	{
		flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
		var android = new AndroidInitializationSettings('icon_notifications_gray');
		var ios = new IOSInitializationSettings();
		var initSettings = new InitializationSettings(android, ios);

		flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

		this.initNotification();
	}


	initNotification() async
	{
		// Tiempo en que va a sonar la notificacion
		var _time = Time(hour, minute, 0);

		var vibrationPattern = Int64List(3);
		vibrationPattern[0] = 1000;
		vibrationPattern[1] = 5000;
		vibrationPattern[2] = 2000;

		// Configuracion para android 
		var android = new AndroidNotificationDetails(
			'channel id 1', 
			'channel NAME 2', 
			'CHANNEL DESCRIPTION 3',
			icon: 'icon_notifications',
			color: Theme.of(context).accentColor,
			largeIconBitmapSource: BitmapSource.Drawable,
			largeIcon: 'icon_notifications',
			priority: Priority.Max,
			importance: Importance.High,
			sound: 'slow_spring_board',
			vibrationPattern: vibrationPattern,
			enableLights: true,
			ledColor: Theme.of(context).accentColor,
			ledOnMs: 2000,
			ledOffMs: 100
		);

		// Configuracion para IOS 
		var iOS = new IOSNotificationDetails(sound: 'slow_spring_board');

		// Configuracion para la notificacion 
		var platform = new NotificationDetails(android, iOS);

		// Mostrar notificacion
		await flutterLocalNotificationsPlugin.showDailyAtTime(
			0, 
			'Hora del inhalador', 
			name, 
			_time, 
			platform
		);
	}

	Future onSelectNotification(String payload) async
	{
		debugPrint("payload: $payload");
		showDialog(context: context, builder: (_) => AlertDialog(title: Text('Notification'), content: Text('$payload'),));
	}
}