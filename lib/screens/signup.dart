import 'package:flutter/material.dart';

// Libraries
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


// Services
import 'package:respikaf/services/HttpHandler.dart';


// Models
import 'package:respikaf/models/TypePacient.dart';


// Screens
import 'package:respikaf/screens/login.dart';


// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';
import 'package:respikaf/widgets/InputSelect.dart';



class SignUp extends StatefulWidget 
{
	final String tag = 'signup';

	@override
	_SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> 
{
	String typePacient;
	List<DropdownMenuItem<dynamic>> items = [];
	final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  TextEditingController ctrlName, ctrlLastName, ctrlPhone, ctrlEmail, ctrlPassword, ctrlAge;



	@override
	void initState() { 
		super.initState();

		this.loadData();	
	}


	void loadData()
	{
		items = [];

		items.add(DropdownMenuItem(
			child: Text('Asma'),
			value: 'Asma',
		));

		items.add(DropdownMenuItem(
			child: Text('Epoc'),
			value: 'Epoc',
		));		
	}

  void setValueTypePacient(dynamic value)
  {
    setState(() => typePacient = value);
  }
		



   void _validateAndSave() async
   {
      final form = formKey.currentState;
      if (form.validate()) {

         setState(() {
            _isLoading = true;
         });

         form.save();

			Map data = {
				'name': ctrlName.text,
				'lastname': ctrlLastName.text,
				'email': ctrlEmail.text,
				'password': ctrlPassword.text,
				'age': ctrlAge.text,
				'phone': ctrlPhone.text,
				'typePacient': typePacient
			};

			print('Data: $data');
			
			var response = await HttpHandler().post('/user/login', data);

	    print('Response: $response');

		
			setState(() {
				_isLoading = false;
			});	


			/*
         new Future.delayed(Duration(seconds: 2), () async {

            setState(() {
               _isLoading = false;
            });


            /*
            _scaffoldKey.currentState.showSnackBar(SnackBar(
               content: Text('No coinciden los datos'),
               duration: Duration(seconds: 3),
               backgroundColor: Colors.red[800]
            ));
            */

            final prefs = await SharedPreferences.getInstance();

            prefs.setString('token', email);

            Navigator.of(context).pushReplacementNamed(Login().tag);

         });
			*/
         

      } else {
         print('Form is invalid');
      }
   }	



	Widget _buidlWidget(BuildContext context) 
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
							key: formKey,
							child: Column(
								children: <Widget>[
                        	Text('Respikaf', style: Theme.of(context).textTheme.title),

									SizedBox(height: 40),
									InputText(label: 'Nombre', typeInput: TextInputType.text, controller: ctrlName,),

									SizedBox(height: 20),
									InputText(label: 'Apellido', typeInput: TextInputType.text, controller: ctrlLastName,),

									SizedBox(height: 20),
									InputText(label: 'Telefono', typeInput: TextInputType.text, controller: ctrlPhone,),

									SizedBox(height: 20),
									InputText(label: 'Correo', typeInput: TextInputType.text, controller: ctrlEmail,),

									SizedBox(height: 20),
									InputText(label: 'Contraseña', typeInput: TextInputType.text, isPassword: true, controller: ctrlPassword,),

									SizedBox(height: 20),
									InputText(label: 'Edad', typeInput: TextInputType.number, controller: ctrlAge,),

									SizedBox(height: 20),									
									InputSelect(items: items, label: 'Tipo de paciente', setValue: setValueTypePacient),

									SizedBox(height: 50),
									RaisedButton(
										elevation: 6,
										onPressed: _validateAndSave,
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


	@override
   Widget build(BuildContext context)
   {
      return Scaffold(
         key: _scaffoldKey,
         body: ModalProgressHUD(child: _buidlWidget(context), inAsyncCall: _isLoading, opacity: 0.4, color: Colors.black)
      );
   }
}

