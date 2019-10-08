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
	bool _loading = true;


	@override
	void initState() 
	{
		super.initState();

		// Obtener datos guardados localmente
		SharedPreferences.getInstance().then((result) {
			setState(() {

				// Obtener el usuario actual
				String _userString = result.getString('user');

				// Parsear y setear el usuario
				_user = User.fromJson(json.decode(_userString));

				// Cambiar estado de cargando
				_loading = false;
			});
		});
	}


	String userName()
	{	
		// Inicializar el nombre
		String _name = "";

		// Comprobar si ya termino de cargar
		if (!_loading) {
			
			// Comprobar si el nombre esta vacio entonces setear el apellido
			if (_user.name.isEmpty) {
				_name = _user.lastname;
			} else {
				_name = _user.name;
			}
		}

		// Regresar el nombre
		return _name;
	}


	String typePacient()
	{	
		// Inicializar el tipo de paciente
		String _type = "Usuario con ";

		// Comprobar si ya termino de cargar
		if (!_loading) {
			// _type += _user.typePatientId;
		}

		// Regresar el tipo de paciente
		return _type;
	}	


	String age()
	{	
		// Inicializar la edad
		String _age = "";

		// Comprobar si ya termino de cargar
		if (!_loading) {
			_age = "${_user.age} años";
		}

		// Regresar la edad
		return _age;
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
								Text(age(), style: Theme.of(context).textTheme.body2),

								SizedBox(height: 5),
								Text(typePacient(), style: Theme.of(context).textTheme.body2)
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
				*/
	

			],
		);
	}
}