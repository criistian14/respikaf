import 'package:flutter/material.dart';


// Libraries
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


// Libraries Custom
import 'package:respikaf/common/notifications.dart';


// Widgets Custom
import 'package:respikaf/components/AlarmItem.dart';
import 'package:respikaf/components/InputText.dart';
import 'package:respikaf/components/InputSelect.dart';
import 'package:respikaf/components/ProgressCustom.dart';
import 'package:respikaf/components/DialogAddClock.dart';


// Services
import 'package:respikaf/services/TypeInhaladorService.dart';


// Models
import 'package:respikaf/models/Alarm.dart';
import 'package:respikaf/models/TypeInhalador.dart';


// Utilities
import 'package:respikaf/common/size_config.dart';



class Settings extends StatefulWidget 
{
	@override
	_SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> 
{
	List<DropdownMenuItem<dynamic>> typesInhaladorItems = [];
  List<TypeInhalador> typesInhalador = [];
	String dateInitialString = '';
	DateTime dateInitial = DateTime.now();
	SharedPreferences prefs;
  int typeInhalador;
  TextEditingController ctrlDose = TextEditingController();


	@override
	void initState() 
	{ 
		super.initState();	
	}


  /*
  * Obtener los tipos de inhalador apropiados para el usuario
  *
  * @return [List<DropdownMenuItem>] typesInhaladorItems
  */
  Future<List<DropdownMenuItem>> _loadTypesIhalador() async 
  {
    // var response = await TypeInhaladorService().getForUser();

    // if (response['status'] == 'success') {
    //   typesInhaladorItems = [];

    //   for (var i = 0; i < response['data'].length; i++) {

    //     TypeInhalador typeInhaladorTemp = TypeInhalador.fromJson(response['data'][i]); 

    //     typesInhalador.add(typeInhaladorTemp);

    //     typesInhaladorItems.add(DropdownMenuItem(
    //       child: Text(typeInhaladorTemp.name),
    //       value: typeInhaladorTemp.id,
    //     ));
    //   }
    // }

    // return typesInhaladorItems;

    return [];
  }


  /*
  * Definir el tipo de paciente y el numero de dosis
  *
  * @param [dynamic] value
  */
  void setValueTypeInhalador(dynamic value) 
  {
    setState(() => typeInhalador = value);

    var typesInhaladorTemp = typesInhalador.where((inhalador) => inhalador.id == value).toList();

    ctrlDose.text = "${typesInhaladorTemp[0].dose}";
  }  


  /*
  * Mostrar un date picker solicitando la fecha para iniciar 
  *
  * @return [DatePicker] showDatePicker
  */
	Future _openPickerDate() async
	{
		DateTime picked = await showDatePicker(
			context: context,
			initialDate: dateInitial,
			firstDate: DateTime.now(),
			lastDate: DateTime(2020),
			builder: (BuildContext context, Widget child) {
				return Theme(
					data: ThemeData(
						primaryColor: Theme.of(context).primaryColor,
						accentColor: Theme.of(context).accentColor,
						dialogBackgroundColor: Theme.of(context).dialogBackgroundColor,
					),
					child: child,
				);
			}
		);

		if (picked != null) setState(() {
			dateInitialString = DateFormat('dd - MMMM - yyyy', 'es').format(picked).toString();
			dateInitial = picked;
		});
	}



	Widget _buildListClocks()
	{
		return ProgressCustom();
	} 



  /*
  * Input para seleccionar el tipo de inhalador
  *
  * @return [Widget] 
  */
  Widget _inputTypeInhalador()
  {
    return Container(
      width: MediaQuery.of(context).size.width / 2.4,
      child: FutureBuilder(
        future: _loadTypesIhalador(),
        builder: (BuildContext context, snapshot)
        {
          if (snapshot.hasData) {
            return InputSelect(
              items: snapshot.data,
              label: 'Tipo de inhalador',
              setValue: setValueTypeInhalador
            );
          }

          return ProgressCustom();
        },
      ),
    );
  }



  /*
  * Renderiza toda la vista
  *
  * @return [Widget] 
  */
  @override
	Widget build(BuildContext context) 
	{
    // Dimensiones estandar 
    SizeConfig().init(context);

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: <Widget>[
				SizedBox(height: 10),

				GestureDetector(
					onTap: _openPickerDate,
					child: AbsorbPointer(
						child: InputText(label: 'Fecha Incio del inhalador', typeInput: TextInputType.datetime, value: dateInitialString)
					)
				),

				SizedBox(height: 28),
        Row(
          children: <Widget>[
            _inputTypeInhalador(),
						
						SizedBox(width: 10,),
						Expanded(
							child: InputText(label: 'N. Dosis', typeInput: TextInputType.number, controller: ctrlDose,),
						),
						
					],
				),

				SizedBox(height: 30),
				Text('Recordatorios', style: Theme.of(context).textTheme.display1),
				Divider(color: Colors.white),

				_buildListClocks(),

				SizedBox(height: 26),
				// Align(
				// 	alignment: Alignment.bottomCenter,
				// 	child: FloatingActionButton(onPressed: _showAddClock, child: Icon(Icons.add)),
				// )
				
			],
		);
	}
}