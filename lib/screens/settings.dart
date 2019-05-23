import 'package:flutter/material.dart';


// Libraries
import 'package:intl/intl.dart';


// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';
import 'package:respikaf/widgets/InputSelect.dart';



class Settings extends StatefulWidget 
{
	@override
	_SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> 
{
	String dateInitial = '';
	List<DropdownMenuItem<dynamic>> items = [];


	@override
	void initState() { 
		super.initState();

		this.loadData();	
	}

	void loadData()
	{
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
	}



	Future _openPickerDate() async
	{
		DateTime picked = await showDatePicker(
			context: context,
			initialDate: DateTime.now(),
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

		if (picked != null) setState(() => dateInitial = DateFormat('dd - MMMM - yyyy', 'es').format(picked).toString());
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
						child: InputText(label: 'Fecha Incio del inhalador', typeInput: TextInputType.datetime, value: dateInitial)
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

				_clocks('Alarma 3 (1:30 pm)', true),

				_clocks('Alarma 4 (8:00 pm)', true),


				SizedBox(height: 26),
				Align(
					alignment: Alignment.bottomCenter,
					child: FloatingActionButton(onPressed: () { }, child: Icon(Icons.add)),
				)
				

			],
		);
	}
}