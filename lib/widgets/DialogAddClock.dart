import 'package:flutter/material.dart';


// Libraries
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';


// Models
import 'package:respikaf/models/Alarm.dart';



class DialogAddClock extends StatefulWidget 
{
	final content;

	DialogAddClock({ this.content });

  @override
  _DialogAddClockState createState() => _DialogAddClockState();
}


class _DialogAddClockState extends State<DialogAddClock> 
{
	String timeInitialString = '';
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
			initialTime: timeInitial
		);
		
		if (picked != null && picked != timeInitial) setState(() {
			timeInitialString = picked.format(context);
			timeInitial = picked;
		});
	}

	Future _saveClock() async
	{
		Alarm _alarmTemp = Alarm(name: ctrlName.text, hour: timeInitialString);
		
		String _alarmString = jsonEncode(_alarmTemp);

		List<String> _clocks = prefs.getStringList('clocks') ?? [];
		_clocks.add(_alarmString);


		prefs.setStringList('clocks', _clocks);


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