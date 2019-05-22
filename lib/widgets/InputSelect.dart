import 'package:flutter/material.dart';


class InputSelect extends StatefulWidget 
{
	final List items;
	final String label;
	final Function(dynamic) setValue;
	

	InputSelect({ @required this.items, @required this.label, this.setValue });

	@override
	_InputSelectState createState() => _InputSelectState();
}



class _InputSelectState extends State<InputSelect> 
{
	var _selected;


	void _changeValue(value)
	{
		setState(() => _selected = value);

		widget.setValue(value);
	}


  	@override
	Widget build(BuildContext context) 
	{
		return Container(
			padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
			width: MediaQuery.of(context).size.width,
			decoration: BoxDecoration(
				border: Border.all(color: Theme.of(context).highlightColor, width: 2.5),
				borderRadius: BorderRadius.all(Radius.circular(5))
			),
			child: DropdownButtonHideUnderline(
				child: DropdownButton(
					isExpanded: true,
					hint: Text(widget.label, style: Theme.of(context).textTheme.body1),
					items: widget.items,
					value: _selected,
					onChanged: _changeValue,
				),
			)
		);
	}
}