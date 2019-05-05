import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


// Screens
import 'package:respikaf/screens/home.dart';
import 'package:respikaf/screens/login.dart';
import 'package:respikaf/screens/signup.dart';



class MyApp extends StatefulWidget 
{
	_MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp>
{
	final routes = <String, WidgetBuilder>{
		Home().tag: (BuildContext context) => Home(),
		Login().tag: (BuildContext context) => Login(),
		SignUp().tag: (BuildContext context) => SignUp()
	};

	ThemeData theme()
	{
		return ThemeData(
			primaryColor: Colors.grey[850],
			accentColor: Colors.lightBlueAccent[400],
			dialogBackgroundColor: Colors.grey[300],
			canvasColor: Colors.grey[850],
			
			buttonTheme: ButtonThemeData(
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
				padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
				buttonColor: Theme.of(context).accentColor
			),

			
			//fontFamily: 'Roboto',
			textTheme: TextTheme(
				title: TextStyle(
					letterSpacing: 2,
					fontFamily: 'Pacifico',
					fontSize: 48,
					color: Colors.white
				),

				subtitle: TextStyle(
					letterSpacing: 2,
					fontFamily: 'Pacifico',
					fontSize: 25,
					color: Colors.white
				),


				display1: TextStyle(
					fontFamily: 'Roboto',
					color: Colors.white,
					fontSize: 20
				),

				display2: TextStyle(
					fontFamily: 'Roboto',
					color: Colors.white,
					fontSize: 25
				),

				display3: TextStyle(
					fontFamily: 'Roboto',
					color: Colors.white,
					fontSize: 28,
					fontWeight: FontWeight.bold
				),



				subhead: TextStyle(
					fontFamily: 'Roboto',
					color: Colors.white,
					fontSize: 17,
					fontWeight: FontWeight.bold
				),				

				body1: TextStyle(
					fontFamily: 'Roboto',
					color: Colors.white,
					fontSize: 17
				),

				body2: TextStyle(
					fontFamily: 'Roboto',
					color: Colors.white,
					fontSize: 15
				)
			)
		);
	} 

	String _result;



	@override
	void initState()
	{
		super.initState();


		SharedPreferences.getInstance().then((result) {
			setState(() {
				_result = (result.getString('token') ?? '');
			});
		});

	}




	Widget _initialRoute() 
	{
		if (_result.isEmpty) {

			return Login();
		} else {

			return Home();
		}	 
	}




	@override
	Widget build(BuildContext context) 
	{
		return MaterialApp(
			localizationsDelegates: [
				GlobalMaterialLocalizations.delegate,
				GlobalWidgetsLocalizations.delegate
			],
			supportedLocales: [
				const Locale("es")
			],
			debugShowCheckedModeBanner: false,
			routes: routes,
			home: _initialRoute(),
			theme: theme()
		);
	}
}





void main() => runApp(MyApp());