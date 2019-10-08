import 'package:flutter/material.dart';

// Models
import 'package:respikaf/models/Alarm.dart';



class AlarmItem extends StatefulWidget 
{
	final Alarm alarm;
	final Function deleteAlarm;
	final int index;
	
	AlarmItem({ this.alarm, this.index, this.deleteAlarm });

	@override
	_AlarmItemState createState() => _AlarmItemState();
}


class _AlarmItemState extends State<AlarmItem> 
{

	void _showOptions()
	{
		SimpleDialog _dialog = SimpleDialog(
			children: <Widget>[
				SimpleDialogOption(
					onPressed: () => widget.deleteAlarm(widget.index),
					child: Text('Eliminar'),
				)
			],
		);


		showDialog(
			context: context, 
			builder: (_) => _dialog
		);
	}


	@override
	Widget build(BuildContext context) 
	{
		return Material(
			child: InkWell(
				onLongPress: _showOptions,
				child: Row(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: <Widget>[
						Text("${widget.alarm.name} - ${widget.alarm.time}", style: Theme.of(context).textTheme.body2),
						Switch(value: widget.alarm.state, onChanged: (value) => setState(() => widget.alarm.state = value))
					],
				)
			)
		);
	}
}