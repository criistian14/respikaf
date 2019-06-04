import 'package:flutter/material.dart';


class ProgressCustom extends StatefulWidget 
{
	@override
	_ProgressCustomState createState() => _ProgressCustomState();
}

class _ProgressCustomState extends State<ProgressCustom> 
{
	@override
	Widget build(BuildContext context) 
	{
		return Container(
			height: 80,
			child: Center(
				child: CircularProgressIndicator(
					valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)
				)
			),
		);
	}
}