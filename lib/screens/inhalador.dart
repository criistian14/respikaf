import 'package:flutter/material.dart';


// Libraries
import 'package:percent_indicator/circular_percent_indicator.dart';


class Inhalador extends StatefulWidget 
{
	@override
	_InhaladorState createState() => _InhaladorState();
}

class _InhaladorState extends State<Inhalador> 
{
	@override
	Widget build(BuildContext context) 
	{
		return Column(
			children: <Widget>[
				Text('Estadisticas del mes', style: Theme.of(context).textTheme.display2),


				SizedBox(height: 20),
				CircularPercentIndicator(
					radius: 150,
					lineWidth: 10,
					circularStrokeCap: CircularStrokeCap.round,
					percent: 1,
					center: Text('100%', style: Theme.of(context).textTheme.display3),
					progressColor: Theme.of(context).accentColor,
					animation: true,
					animationDuration: 1200
				),


				SizedBox(height: 30),
				Row(
					mainAxisAlignment: MainAxisAlignment.spaceAround,
					children: <Widget>[
						Column(
							children: <Widget>[
								Text('0', style: Theme.of(context).textTheme.display2),
								Text('Faltantes'),

								SizedBox(height: 35),
								Text('0', style: Theme.of(context).textTheme.display2),
								Text('Rechazadas')
							],
						),

						Column(
							children: <Widget>[
								Text('0', style: Theme.of(context).textTheme.display2),
								Text('Completadas'),

								SizedBox(height: 35),
								Text('0', style: Theme.of(context).textTheme.display2),
								Text('Siguiente mes')
							],
						),
					],
				),		

			],
		);
	}
}