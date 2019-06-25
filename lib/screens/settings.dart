import 'package:flutter/material.dart';


// Libraries
import 'package:intl/intl.dart';
import 'package:respikaf/widgets/DialogAddClock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';


// Widgets Custom
import 'package:respikaf/widgets/AlarmItem.dart';
import 'package:respikaf/widgets/InputText.dart';
import 'package:respikaf/widgets/InputSelect.dart';
import 'package:respikaf/widgets/ProgressCustom.dart';


// Models
import 'package:respikaf/models/Alarm.dart';



class Settings extends StatefulWidget 
{
	@override
	_SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> 
{
	List<DropdownMenuItem<dynamic>> items = [];
	List<String> _alarmsString;
	List<Alarm> _alarms;
	String dateInitialString = '';
	bool _loadingClocks = true;
	DateTime dateInitial = DateTime.now();
	SharedPreferences prefs;
	FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


	@override
	void initState() { 
		super.initState();

		flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
		var android = new AndroidInitializationSettings('app_icon');
		var ios = new IOSInitializationSettings();
		var initSettings = new InitializationSettings(android, ios);

		flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: onSelectNotification);

		this.loadData();	
	}


	Future onSelectNotification(String payload) async
	{
		debugPrint("payload: $payload");
		showDialog(context: context, builder: (_) => AlertDialog(title: Text('Notification'), content: Text('$payload'),));
	}


	@override
	void dispose() 
	{
		super.dispose();

		this.saveData();
	}


	void loadData() async
	{
		// Inicializar variables para no repetir datos
		items = [];
		_alarmsString = [];
		_alarms = [];
		
		prefs  = await SharedPreferences.getInstance();

		// Obtener las alarmas guardadas
		_alarmsString = prefs.getStringList('alarms') ?? [];

		// Parsear y setear las alarmas
		_alarmsString.forEach((alarm) => _alarms.add(Alarm.fromJson(jsonDecode(alarm))) );

		// Cancelar cargando
		setState(() => _loadingClocks = false);

		// Obtener tipos de inhalador
		items.add(DropdownMenuItem(
			child: Text('Cartucho presurizado'),
			value: 'Cartucho presurizado',
		));	
    	items.add(DropdownMenuItem(
			child: Text('Polvo seco'),
			value: 'Polvo seco',
		));	
    	items.add(DropdownMenuItem(
			child: Text('Niebla fina'),
			value: 'Niebla fina',
		));	
	}


	void saveData() async
	{
		// Inicializar variable
		_alarmsString = [];

		// Recorrer lista de alarmas y parsearlas a String guardandolas en lista de Stings
		_alarms.forEach((alarmTemp) => _alarmsString.add(jsonEncode(alarmTemp)));

		// Guardar lista parseada
		prefs.setStringList('alarms', _alarmsString);
	}


	Future _openPickerDate() async
	{
		DateTime picked = await showDatePicker(
			context: context,
			initialDate: dateInitial,
			firstDate: DateTime(2016),
			lastDate: DateTime(2020),
			builder: (BuildContext context, Widget child) {
				return Theme(
					data: ThemeData(
						primaryColor: Theme.of(context).primaryColor,
						accentColor: Theme.of(context).accentColor,
						dialogBackgroundColor: Theme.of(context).dialogBackgroundColor,
					),
					child: child,
				);
			}
		);

		if (picked != null) setState(() {
			dateInitialString = DateFormat('dd - MMMM - yyyy', 'es').format(picked).toString();
			dateInitial = picked;
		});
	}


	_showAddClock()
	{
		showDialog(
			context: context,
			builder: (context) => DialogAddClock(alarms: _alarms)
		).then((value) => setState(() {}));
	}


	Widget _listClocks()
	{
		return Container(
			width: MediaQuery.of(context).size.width,
			height: MediaQuery.of(context).size.height / 4,
			child: ListView.builder(
				//physics: NeverScrollableScrollPhysics(),
				itemCount: _alarms.length,
				itemBuilder: (context, index) => AlarmItem(alarm: _alarms[index]),
			)
		);
	} 

	
	Widget _buildListClocks()
	{
		return (_loadingClocks)
			? ProgressCustom()
			: _listClocks();
	} 



	_showNotification() async
	{
		// Tiempo en que va a sonar la notificacion
    	var scheduledNotificationDateTime = DateTime.now().add(Duration(seconds: 5));

		var vibrationPattern = Int64List(3);
		vibrationPattern[0] = 1000;
		vibrationPattern[1] = 5000;
		vibrationPattern[2] = 2000;

		// Configuracion para android 
		var android = new AndroidNotificationDetails(
			'channel id', 
			'channel NAME', 
			'CHANNEL DESCRIPTION',
			icon: 'icon_notifications',
			largeIconBitmapSource: BitmapSource.Drawable,
			largeIcon: 'icon_notifications',
			priority: Priority.Max,
			importance: Importance.High,
			sound: 'slow_spring_board',
			vibrationPattern: vibrationPattern,
			color: Theme.of(context).accentColor,
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
		await flutterLocalNotificationsPlugin.schedule(
			0, 
			'Hora de aspirar', 
			'Llego la hora', 
			scheduledNotificationDateTime, 
			platform
		);
	}



  	@override
	Widget build(BuildContext context) 
	{
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: <Widget>[
				SizedBox(height: 10),

				GestureDetector(
					onTap: _openPickerDate,
					child: AbsorbPointer(
						child: InputText(label: 'Fecha Incio del inhalador', typeInput: TextInputType.datetime, value: dateInitialString)
					)
				),

				SizedBox(height: 28),
				Row(
					children: <Widget>[
						Container(
							width: MediaQuery.of(context).size.width / 2.4,
							child: InputSelect(items: items, label: 'Tipo de inhalador'),
						),
						
						SizedBox(width: 10,),
						Expanded(
							child: InputText(label: 'N. Dosis', typeInput: TextInputType.number),
						),
						
					],
				),

				SizedBox(height: 30),
				Text('Recordatorios', style: Theme.of(context).textTheme.display1),
				Divider(color: Colors.white),


				_buildListClocks(),
			
				// _alarmsString('Alarma 1 (10:30 am)', true),

				RaisedButton(
					onPressed: _showNotification,
					child: Text('Notification'),
				),

				SizedBox(height: 26),
				Align(
					alignment: Alignment.bottomCenter,
					child: FloatingActionButton(onPressed: _showAddClock, child: Icon(Icons.add)),
				)
				

			],
		);
	}
}