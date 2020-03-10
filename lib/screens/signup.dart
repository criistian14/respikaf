import 'package:flutter/material.dart';

// Libraries
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Services
import 'package:respikaf/services/TypePatientService.dart';
import 'package:respikaf/services/UserService.dart';

// Models
import 'package:respikaf/models/TypePatient.dart';
import 'package:respikaf/models/User.dart';

// Screens
import 'package:respikaf/screens/login.dart';

// Components Custom
import 'package:respikaf/components/InputText.dart';
import 'package:respikaf/components/InputSelect.dart';
import 'package:respikaf/components/ProgressCustom.dart';

// Utilities
import 'package:respikaf/common/size_config.dart';


class SignUp extends StatefulWidget 
{
  final String tag = 'signup';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> 
{
  int typePatient;
  List<DropdownMenuItem<dynamic>> items = [];
  List<String> _listTextErrors = [];
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  TextEditingController ctrlName = TextEditingController(),
      ctrlLastName = TextEditingController(),
      ctrlPhone = TextEditingController(),
      ctrlEmail = TextEditingController(),
      ctrlPassword = TextEditingController(),
      ctrlPasswordConfirmation = TextEditingController(),
      ctrlAge = TextEditingController();

  @override
  void initState() 
  {
    super.initState();
  }

  /*
   * Cargar tipos de paciente
   * 
   * @return [List]
   */
  Future<List<DropdownMenuItem>> _loadTypesPatients() async 
  {
    items = [];

    var response = await TypePatientService().getAll();
    
    if (response['status'] == 'success') {

      for (var i = 0; i < response['data'].length; i++) {

        TypePatient typePatientTemp = TypePatient.fromJson(response['data'][i]); 

        items.add(DropdownMenuItem(
          child: Text(typePatientTemp.type),
          value: typePatientTemp.id,
        ));
      }
    }

    return items;
  }


  /*
  * Definir el tipo de paciente
  *
  * @param [dynamic] value
  */
  void setValueTypePatient(dynamic value) 
  {
    setState(() => typePatient = value);
  }


  /*
  * Text Inputs del formulario
  *
  * @return [Widget] 
  */
  Widget textInputs()
  {
    double _height = SizeConfig.blockSizeVertical * 4;

    if (SizeConfig.orientation == Orientation.landscape)
      _height = SizeConfig.blockSizeVertical * 4;

    return Column(
      children: <Widget>[
        InputText(
          label: 'Nombre',
          typeInput: TextInputType.text,
          controller: ctrlName,
        ),
        SizedBox(height: _height),

        InputText(
          label: 'Apellido',
          typeInput: TextInputType.text,
          controller: ctrlLastName,
        ),
        SizedBox(height: _height),

        InputText(
          label: 'Numero Celular',
          typeInput: TextInputType.phone,
          controller: ctrlPhone,
        ),
        SizedBox(height: _height),

        InputText(
          label: 'Correo',
          typeInput: TextInputType.text,
          controller: ctrlEmail,
        ),
        SizedBox(height: _height),

        InputText(
          label: 'Contraseña',
          typeInput: TextInputType.text,
          isPassword: true,
          controller: ctrlPassword,
        ),
        SizedBox(height: _height),

        InputText(
          label: 'Confirma Contraseña',
          typeInput: TextInputType.text,
          isPassword: true,
          controller: ctrlPasswordConfirmation,
        ),
        SizedBox(height: _height),

        InputText(
          label: 'Edad',
          typeInput: TextInputType.number,
          controller: ctrlAge,
        ),
        SizedBox(height: _height),

        FutureBuilder(
          future: _loadTypesPatients(),
          builder: (BuildContext context, snapshot)
          {
            if (snapshot.hasData) {
              return InputSelect(
                items: items,
                label: 'Tipo de paciente',
                setValue: setValueTypePatient
              );
            }

            return ProgressCustom();
          },
        ),
      ],
    );
  }


  /*
  * Validar el formulario y enviarlo
  *
  */
  void _validateAndSave() async 
  {
    final form = formKey.currentState;

    if (form.validate()) {

      setState(() {
        _isLoading = true;
      });

      form.save();
 
      
      User user = new User(
        name: ctrlName.text,
        lastname: ctrlLastName.text,
        email: ctrlEmail.text,
        password: ctrlPassword.text,
        passwordConfirmation: ctrlPasswordConfirmation.text,
        phone: ctrlPhone.text,
        age: int.parse(ctrlAge.text),
        typePatientId: typePatient,
      );

      var response = await UserService().create(data: user.toJson());

      setState(() {
        _isLoading = false;
      });


      if (response['status'] == 'success') {

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(response['message']),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green)
        );

        await Future.delayed(Duration(seconds: 4));

        Navigator.of(context).pushReplacementNamed(Login().tag);

      } else {

        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(response['message']),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red[800])
        );

        Map _list = response['errors'];

        _listTextErrors = [];

        _list.forEach((key, value) {
          setState(() {
            _listTextErrors.add(value[0]);
          });
        });

      }
      
    } else {
      print('Form is invalid');
    }
  }


  /*
  * Text Inputs del formulario
  *
  * @return [Widget] 
  */
  Widget _showErrorsForm()
  {
    return ListView.builder(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _listTextErrors.length,
        itemBuilder: (BuildContext context, int index)
        {
          return Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
            child: Text(
              "- ${_listTextErrors[index]}", 
              style: TextStyle(
                color: Colors.red[800],
                fontWeight: FontWeight.w600
                )
              )
            );
        },
      );
  }


  /*
  * Contenido de la vista
  *
  * @return [Widget] 
  */
  Widget _buidlWidget(BuildContext context) 
  {
    return Container(
        // fit: StackFit.expand,
        //children: <Widget>[
          
        child:  SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  
                  Text('Respikaf', style: Theme.of(context).textTheme.title),
                  SizedBox(height: SizeConfig.blockSizeVertical * 8),

                  textInputs(),

                  _showErrorsForm(),

                  SizedBox(height: SizeConfig.blockSizeVertical * 6),


                  RaisedButton(
                    elevation: 6,
                    onPressed:  _validateAndSave,
                    child: Text('Crear Cuenta',
                        style: Theme.of(context).textTheme.display1),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '¿Ya tienes cuenta?',
                        style: Theme.of(context).textTheme.body1
                      ),

                      FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, Login().tag);
                          },
                          child: Text(
                            'Ingresa!',
                            style: Theme.of(context).textTheme.subhead)
                          )
                    ],
                  ),
                ],
              ),
            )
          ),
        // ],
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

    return Scaffold(
      key: _scaffoldKey,
      body: ModalProgressHUD(
        child: _buidlWidget(context),
        inAsyncCall: _isLoading,
        opacity: 0.4,
        color: Colors.black
      )
    );
  }
}
