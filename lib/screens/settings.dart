import 'package:flutter/material.dart';


// Libraries
import 'package:intl/intl.dart';
import 'package:respikaf/models/Alarm.dart';
import 'package:respikaf/widgets/DialogAddClock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';
import 'package:respikaf/widgets/InputSelect.dart';
import 'package:respikaf/widgets/ProgressCustom.dart';



class Settings extends StatefulWidget 
{
	@override
	_SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> 
{
	String dateInitialString = '';
	DateTime dateInitial = DateTime.now();
	List<DropdownMenuItem<dynamic>> items = [];
	SharedPreferences prefs;
	bool _loadingClocks = true;
	List<String> _clocks;

	@override
	void initState() { 
		super.initState();

		this.loadData();	
	}

	void loadData() async
	{
		items = [];
		_clocks = [];
		

		prefs  = await SharedPreferences.getInstance();

		_clocks = prefs.getStringList('clocks') ?? [];

		setState(() => _loadingClocks = false);


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
			builder: (context) => DialogAddClock()
		);
	}


	Widget _clockItem(String json)
	{
		Alarm _tempAlarm = Alarm.fromJson(jsonDecode(json));

		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
				Text("${_tempAlarm.name} - ${_tempAlarm.hour}", style: Theme.of(context).textTheme.body2),
				Switch(value: true, onChanged: (e) { })
			],
		);
	}


	Widget _listClocks()
	{
		return Container(
			width: MediaQuery.of(context).size.width,
			height: MediaQuery.of(context).size.height / 4,
			child: ListView.builder(
				//physics: NeverScrollableScrollPhysics(),
				itemCount: _clocks.length,
				itemBuilder: (context, index) => _clockItem(_clocks[index]),
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
			
				// _clocks('Alarma 1 (10:30 am)', true),


				SizedBox(height: 26),
				Align(
					alignment: Alignment.bottomCenter,
					child: FloatingActionButton(onPressed: _showAddClock, child: Icon(Icons.add)),
				)
				

			],
		);
	}
}