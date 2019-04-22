import 'package:flutter/material.dart';


// Libraries
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';


// Pages
import 'package:respikaf/screens/inhalador.dart';
import 'package:respikaf/screens/guide.dart';
import 'package:respikaf/screens/profile.dart';
import 'package:respikaf/screens/settings.dart';



class Home extends StatefulWidget {
	final String tag = 'home';

	@override
	_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> 
{
	int _selectedIndex  = 0;
	final _pagesOptions = [
		Inhalador(),
		Guide(),
		Profile(),
		Settings()
	];






	void _closeSession() async
	{
		final prefs = await SharedPreferences.getInstance();

		prefs.remove('token');

		Navigator.of(context).pushReplacementNamed('login');
	}

	void _onItemTapped(int index)
	{
		setState(() {
			_selectedIndex = index; 
		});
	}



	Widget _appBar()
	{
		return AppBar(
			title: Text('Respikaf', style: Theme.of(context).textTheme.subtitle),
			actions: <Widget>[
				Tooltip(
					message: 'Salir',
					child: IconButton(icon: Icon(Icons.exit_to_app), onPressed: _closeSession) 
				)
			],
		);
	}

	Widget _bottomAppBar()
	{
		return BubbleBottomBar(
			opacity: 0.2,
			elevation: 10,
			currentIndex: _selectedIndex,
			onTap: _onItemTapped,
			backgroundColor: Theme.of(context).primaryColor,
			hasInk: true,
			inkColor: Theme.of(context).primaryColor,
			items: <BubbleBottomBarItem>[
				BubbleBottomBarItem(backgroundColor: Theme.of(context).accentColor, icon: Icon(Icons.home), title: Text('Inhalador')),
				BubbleBottomBarItem(backgroundColor: Theme.of(context).accentColor, icon: Icon(Icons.chrome_reader_mode), title: Text('Manual')),
				BubbleBottomBarItem(backgroundColor: Theme.of(context).accentColor, icon: Icon(Icons.account_circle), title: Text('Perfil')),
				BubbleBottomBarItem(backgroundColor: Theme.of(context).accentColor, icon: Icon(Icons.settings), title: Text('Configuracion'))
			],
		);
	}


	@override
	Widget build(BuildContext context) 
	{
		return Scaffold(
			appBar: _appBar(),
			body: Container(
				height: MediaQuery.of(context).size.height,
				width: MediaQuery.of(context).size.width,
				padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
				decoration: BoxDecoration(
					color: Theme.of(context).primaryColor
				),
				child: SingleChildScrollView(
					child: _pagesOptions.elementAt(_selectedIndex)
				),
			),
			bottomNavigationBar: _bottomAppBar()
		);
	}
}