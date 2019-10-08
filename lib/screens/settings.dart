import 'package:flutter/material.dart';


// Libraries
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


// Libraries Custom
import 'package:respikaf/common/notifications.dart';


// Widgets Custom
import 'package:respikaf/components/AlarmItem.dart';
import 'package:respikaf/components/InputText.dart';
import 'package:respikaf/components/InputSelect.dart';
import 'package:respikaf/components/ProgressCustom.dart';
import 'package:respikaf/components/DialogAddClock.dart';


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


	@override
	void initState() 
	{ 
		super.initState();

		this.loadData();	
	}


	@override
	void deactivate() 
	{
		// Generar las notificaciones
		this._generateNotification();

		super.deactivate();
	}


	@override
	void dispose() 
	{
		this.saveData();

		super.dispose();
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

		// Generar las notificaciones
		_generateNotification();

		// Cancelar cargando
		setState(() => _loadingClocks = false);

		// Obtener tipos de inhalador

    /*
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
    */
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


	_generateNotification()
	{
		// Limpiar todas las notificaciones
		Notifications().clearNotification();

		// Recorrer las alarmas para activar las notificaciones
		_alarms.forEach((alarm) {
			
			// Comprobar si la arma esta activa
			if (alarm.state) {
				
				// Crear la notificacion
				Notifications().createNotification(
					context: context, 
					hour: alarm.hour, 
					minute: alarm.minute, 
					name: alarm.name
				);
			}
		});
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


	void _showAddClock()
	{
		showDialog(
			context: context,
			builder: (context) => DialogAddClock(alarms: _alarms)
		).then((value) => setState(() {}));
	}


	void deleteAlarm(index)
	{
		_alarms.removeAt(index);

		setState(() { });

		Navigator.of(context).pop();
	}


	Widget _listClocks()
	{
		return Container(
			width: MediaQuery.of(context).size.width,
			height: MediaQuery.of(context).size.height / 4,
			child: ListView.builder(
				//physics: NeverScrollableScrollPhysics(),
				itemCount: _alarms.length,
				itemBuilder: (context, index) => AlarmItem(
					alarm: _alarms[index], 
					deleteAlarm: deleteAlarm, 
					index: index
				),
			)
		);
	} 

	
	Widget _buildListClocks()
	{
		return (_loadingClocks)
			? ProgressCustom()
			: _listClocks();
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

				SizedBox(height: 26),
				Align(
					alignment: Alignment.bottomCenter,
					child: FloatingActionButton(onPressed: _showAddClock, child: Icon(Icons.add)),
				)
				
			],
		);
	}
}