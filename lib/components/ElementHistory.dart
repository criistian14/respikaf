import 'package:flutter/material.dart';



class ElementHistory extends StatefulWidget 
{
	final String hour, name;

	ElementHistory({ this.hour, this.name});

	@override
	_ElementHistoryState createState() => _ElementHistoryState();
}


class _ElementHistoryState extends State<ElementHistory> 
{
	@override
	Widget build(BuildContext context) 
	{
		return Container(
			padding: EdgeInsets.all(0),
			margin: EdgeInsets.all(0),
			width: MediaQuery.of(context).size.width,
			child: Card(
				color: Theme.of(context).primaryColor,
				elevation: .5,
				child: Padding(
					padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
					child: Row(
						children: <Widget>[
							Text(widget.hour, style: Theme.of(context).textTheme.subhead),
							
							SizedBox(width: 10),
							Text(widget.name, style: Theme.of(context).textTheme.body2),
						],
					),
				),
			),
		);
	}
}