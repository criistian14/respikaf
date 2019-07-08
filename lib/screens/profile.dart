import 'package:flutter/material.dart';


// Libraries
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


// Models
import 'package:respikaf/models/User.dart';



class Profile extends StatefulWidget 
{
	@override
	_ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> 
{
	User _user;


	@override
	void initState() 
	{
		super.initState();

		SharedPreferences.getInstance().then((result) {
			setState(() {
				_user = json.decode(result.getString('user'));

				print("User Json ${result.getString('user')}");
			});
		});
	}

	Widget _elementHistory(String hour, String date)
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
							Text(hour, style: Theme.of(context).textTheme.subhead),
							
							SizedBox(width: 10),
							Text(date, style: Theme.of(context).textTheme.body2),
						],
					),
				),
			),
		);
	}

	String userName()
	{	
		
	/*
		if (_user.firstName == '') {
			return _user.lastName;
		}

		return _user.firstName;
		*/
		return '';
	}


	@override
	Widget build(BuildContext context) 
	{
		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: <Widget>[

				Row(
					children: <Widget>[
						CircleAvatar(
							backgroundImage: AssetImage('images/user_placeholder.png'),
							radius: 40,
						),

						SizedBox(width: 10),
						Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								Text(userName(), style: Theme.of(context).textTheme.display1),

								SizedBox(height: 5),
								Text(_user.age.toString(), style: Theme.of(context).textTheme.body2),

								SizedBox(height: 5),
								Text("Usuario con ${_user.typePacient}", style: Theme.of(context).textTheme.body2)
							],
						)
					],
				),

				SizedBox(height: 30),
				Text('Historial', style: Theme.of(context).textTheme.display1),

				Container(
					margin: EdgeInsets.symmetric(vertical: 5),
					height: 1,
					decoration: BoxDecoration(
						color: Colors.white
					),
				),

				/*
				_elementHistory('01:30 pm', 'Hoy'),

				_elementHistory('10:00 am', 'Hoy'),
				
				_elementHistory('01:30 pm', '02 de Abril del 2019'),

				_elementHistory('01:30 pm', '01 de Abril del 2019'),
				*/
	

			],
		);
	}
}