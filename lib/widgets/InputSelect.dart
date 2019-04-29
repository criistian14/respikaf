import 'package:flutter/material.dart';


class InputSelect extends StatefulWidget 
{
	final List<String> items;
	final String label;

	InputSelect({ @required this.items, @required this.label });

	@override
	_InputSelectState createState() => _InputSelectState();
}



class _InputSelectState extends State<InputSelect> 
{
	List<DropdownMenuItem<int>> listDrop = [];
	int _selected;


	@override
	void initState() {
		super.initState();

		this.loadData();
	}

	void loadData()
	{
		listDrop = [];
		var i = 0;	

		widget.items.forEach((value) {
			listDrop.add(DropdownMenuItem(
				child: Text(value),
				value: i,
			));

			i++;
		});
	}


	void _changeValue(value)
	{
		setState(() => _selected = value);
	}


  	@override
	Widget build(BuildContext context) 
	{
		return DropdownButton(
			hint: Text(widget.label, style: Theme.of(context).textTheme.body1),
			items: listDrop,
			value: _selected,
			onChanged: _changeValue,
		);
	}
}