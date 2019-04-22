import 'package:flutter/material.dart';


class Guide extends StatefulWidget 
{
	@override
	_GuideState createState() => _GuideState();
}

class _GuideState extends State<Guide> 
{
	@override
	Widget build(BuildContext context) 
	{
		return Container(
			child: Image.asset('images/manual.png'),
		);
	}
}


