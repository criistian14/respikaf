import 'package:flutter/material.dart';


// Libraries
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Libraries Custom
import 'package:respikaf/common/notifications.dart';

// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';


// Models
import 'package:respikaf/models/Alarm.dart';



class DialogAddClock extends StatefulWidget 
{
	final List<Alarm> alarms;

	DialogAddClock({ @required this.alarms });

  @override
  _DialogAddClockState createState() => _DialogAddClockState();
}


class _DialogAddClockState extends State<DialogAddClock> 
{
	String timeInitialString = '';
	bool state = true;
	TimeOfDay timeInitial = TimeOfDay.now();
	TextEditingController ctrlHour = new TextEditingController(),
								ctrlName = new TextEditingController();
	SharedPreferences prefs;


	@override
	void initState() 
	{ 
	  	super.initState();
	  
		this.loadData();
	}

	void loadData() async
	{
		prefs  = await SharedPreferences.getInstance();
	}
	
	Future _openPickerTime() async
	{
		TimeOfDay picked = await showTimePicker(
			context: context,
			initialTime: timeInitial,
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
		
		if (picked != null && picked != timeInitial) setState(() {
			timeInitialString = picked.format(context);
			timeInitial = picked;
		});
	}

	
	Future _saveClock() async
	{
		// Crear alarma temporal
		Alarm _alarmTemp = new Alarm(
			name: ctrlName.text, 
			hour: timeInitial.hour, 
			minute: timeInitial.minute, 
			state: state,
			time: timeInitialString
		);

		// Agregar alarma a la lista para renderizarla
		widget.alarms.add(_alarmTemp);

		// Parsear objeto a String
		String _alarmString = jsonEncode(_alarmTemp);

		// Obetener lista de alarmas o crearla sino existe
		List<String> _alarms = prefs.getStringList('alarms') ?? [];

		// Añadir objeto (String) a lista de Strings
		_alarms.add(_alarmString);

		// Guardar lista de Strings
		prefs.setStringList('alarms', _alarms);
	
		// Comprobar si la arma esta activa
		if (_alarmTemp.state) {

			// Crear la notificacion
			Notifications().createNotification(
				context: context, 
				hour: _alarmTemp.hour, 
				minute: _alarmTemp.minute, 
				name: _alarmTemp.name
			);
		}

		// Cerrar modal
		Navigator.of(context).pop();
	}



  @override
  Widget build(BuildContext context) 
  {
	 return AlertDialog(
			content: SingleChildScrollView(
				child: Column(
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						Row(
							children: <Widget>[
								Text('Nueva Alarma', style: Theme.of(context).textTheme.display2),
								Spacer(flex: 2),

								InkWell(
									onTap: () => Navigator.of(context).pop(),
									child: Icon(Icons.close, color: Theme.of(context).highlightColor)
								)
							],
						),

						SizedBox(height: 20),
						InputText(label: 'Nombre',typeInput: TextInputType.text, controller: ctrlName),

						SizedBox(height: 30),
						GestureDetector(
							onTap: _openPickerTime,
							child: AbsorbPointer(
								child: InputText(label: 'Hora', typeInput: TextInputType.datetime, value: timeInitialString)
							)
						),

						SizedBox(height: 10),
						Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: <Widget>[
								Text('¿Activa?'),
								Switch(value: state, onChanged: (value) => setState(() => state = value), ),
						],),

						SizedBox(height: 25),

						RaisedButton(
							onPressed: _saveClock,
							child: Text('Crear', style: Theme.of(context).textTheme.display1),
						)
					],
				),
			),
			shape: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
		);
  }
}