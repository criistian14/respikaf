import 'package:flutter/material.dart';


// Libraries
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';
import 'package:respikaf/widgets/InputSelect.dart';


// Models
import 'package:respikaf/models/Alarm.dart';


class Settings extends StatefulWidget 
{
	@override
	_SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> 
{
	String dateInitialString = '', timeInitialString = '';
	TimeOfDay timeInitial = TimeOfDay.now();
	DateTime dateInitial = DateTime.now();
	List<DropdownMenuItem<dynamic>> items = [], itemsFormatTime = [];
	TextEditingController ctrlHour = new TextEditingController(),
								ctrlName = new TextEditingController();

	SharedPreferences prefs;

	@override
	void initState() { 
		super.initState();

		this.loadData();	
	}

	void loadData() async
	{
		prefs  = await SharedPreferences.getInstance();

		items = [];

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

		itemsFormatTime.add(DropdownMenuItem(
			child: Text('PM'),
			value: 'PM',
		));

		itemsFormatTime.add(DropdownMenuItem(
			child: Text('AM'),
			value: 'AM',
		));
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

	_saveClock()
	{
		Alarm alarmTemp = Alarm(name: ctrlName.text, hour: timeInitialString);
		
		String alarmString = jsonEncode(alarmTemp);

		// prefs.setStringList('clocks', List);

		print(alarmString);

		Navigator.of(context).pop();
	}


	_showAddClock()
	{
		Alert(
			context: context,
			style: AlertStyle(
				titleStyle: Theme.of(context).textTheme.display2,
				alertBorder: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(10),
					side: BorderSide(color: Colors.black)
				)
			),
			title: 'Nueva Alarma',
			content: Column(
				children: <Widget>[
					SizedBox(height: 20),
					InputText(label: 'Nombre',typeInput: TextInputType.text, controller: ctrlName),

					SizedBox(height: 30),
					GestureDetector(
						onTap: _openPickerTime,
						child: AbsorbPointer(
							child: InputText(label: 'Hora', typeInput: TextInputType.datetime, value: timeInitialString)
						)
					),
				],
			),
			buttons: [		

				DialogButton(
					onPressed: _saveClock,
					child: Text(
					"CREAR"
					),
				),
			]
		).show();
	}


	Widget _clocks(String name, bool state)
	{
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
				Text(name, style: Theme.of(context).textTheme.body2),
				Switch(value: state, onChanged: (e) { })
			],
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
				_clocks('Alarma 1 (10:30 am)', true),

				_clocks('Alarma 2 (11:00 am)', false),


				SizedBox(height: 26),
				Align(
					alignment: Alignment.bottomCenter,
					child: FloatingActionButton(onPressed: _showAddClock, child: Icon(Icons.add)),
				)
				

			],
		);
	}
}