import 'package:flutter/material.dart';


// Screens
import 'package:respikaf/screens/login.dart';


// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';



class SignUp extends StatefulWidget 
{
	final String tag = 'signup';

	@override
	_SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> 
{
	String name, lastName, email, password, phone, age;

	void setValue(String value)
	{
		setState(() {
         value = value;
      });
	}


	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			body: Container(
				decoration: BoxDecoration(
					color: Theme.of(context).primaryColor
				),
				child: Center(
					child: SingleChildScrollView(
               	padding: EdgeInsets.symmetric(horizontal: 40, vertical: 28),
						child: Form(
							child: Column(
								children: <Widget>[
                        	Text('Respikaf', style: Theme.of(context).textTheme.title),

									SizedBox(height: 40),
									InputText(label: 'Nombre', typeInput: TextInputType.text, setValue: setValue),

									SizedBox(height: 20),
									InputText(label: 'Apellido', typeInput: TextInputType.text, setValue: setValue),

									SizedBox(height: 20),
									InputText(label: 'Telefono', typeInput: TextInputType.text, setValue: setValue),

									SizedBox(height: 20),
									InputText(label: 'Correo', typeInput: TextInputType.text, setValue: setValue),

									SizedBox(height: 20),
									InputText(label: 'Contraseña', typeInput: TextInputType.text, isPassword: true, setValue: setValue),

									SizedBox(height: 20),
									InputText(label: 'Edad', typeInput: TextInputType.number, setValue: setValue),

									SizedBox(height: 50),
									RaisedButton(
										shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
										padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
										elevation: 6,
										textColor: Colors.white,
										color: Theme.of(context).accentColor,
										onPressed: () { },
										child: Text('Crear Cuenta', style: Theme.of(context).textTheme.display1),
									),
                        
									SizedBox(height: 38),
									Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: <Widget>[
											Text('¿Ya tienes cuenta?', style: Theme.of(context).textTheme.body1),

											// SizedBox(width: 4),

											FlatButton(
												padding: EdgeInsets.all(0),
												onPressed: () {
													Navigator.pushReplacementNamed(context, Login().tag);
												},
												child: Text('Ingresa!', style: Theme.of(context).textTheme.subhead)
											)
											
										],
									),
								],
							),
						)
					),
				),
			),
		);
	}
}
