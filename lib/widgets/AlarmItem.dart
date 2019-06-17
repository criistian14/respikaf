import 'package:flutter/material.dart';

// Models
import 'package:respikaf/models/Alarm.dart';



class AlarmItem extends StatefulWidget 
{
	final Alarm alarm;
	
	AlarmItem({ this.alarm });

	@override
	_AlarmItemState createState() => _AlarmItemState();
}


class _AlarmItemState extends State<AlarmItem> 
{
	@override
	Widget build(BuildContext context) 
	{
		return Row(
			mainAxisAlignment: MainAxisAlignment.spaceBetween,
			children: <Widget>[
				Text("${widget.alarm.name} - ${widget.alarm.hour}", style: Theme.of(context).textTheme.body2),
				Switch(value: widget.alarm.state, onChanged: (value) => setState(() => widget.alarm.state = value))
			],
		);
	}
}