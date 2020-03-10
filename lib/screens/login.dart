import 'package:flutter/material.dart';

// Libraries
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Widgets Custom
import 'package:respikaf/components/InputText.dart';

// Services
import 'package:respikaf/services/UserService.dart';

// Screens
import 'package:respikaf/screens/home.dart';
import 'package:respikaf/screens/signup.dart';
import 'package:respikaf/screens/recover_password.dart';

// Models
import 'package:respikaf/models/User.dart';

// Utilities
import 'package:respikaf/common/size_config.dart';


class Login extends StatefulWidget 
{
  final String tag = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> 
{
  String email;
  String password;
  final formKey = GlobalKey<FormState>();
  final url = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  TextEditingController ctrlEmail = TextEditingController(),
      ctrlPassword = TextEditingController();


  /*
  * Validar el formulario y enviarlo
  */
  void _validateAndSave() async 
  {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });

      form.save();

      Map data = {
        'email': ctrlEmail.text,
        'password': ctrlPassword.text,
      };

      var response = await UserService().login(data: data);


      setState(() {
        _isLoading = false;
      });

      if (response["status"] == "success") {

        final prefs = await SharedPreferences.getInstance();

        String tokenFull = "${response['token_type']} ${response['access_token']}";
        int sizeString = tokenFull.length;

        prefs.setString('token1', tokenFull.substring(0, (sizeString / 2).ceil()));
        prefs.setString('token2', tokenFull.substring((sizeString / 2).ceil(), sizeString));


        User _userTemp = User.fromJson(response["user"]);
        String _userString = jsonEncode(_userTemp);

        prefs.setString('user', _userString);

        Navigator.of(context).pushReplacementNamed(Home().tag);

      } else {

        _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(response['message']),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red[800]));
      } 

    } else {
      print('Form is invalid');
    }
  }


  /*
   * Texto para registrarse
   * 
   * @return [Widget]
   */
  Widget _textRegister()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '¿Aun no tienes cuenta?',
          style: Theme.of(context).textTheme.body1
        ),

        SizedBox(width: 10),
        FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              Navigator.pushNamed(context, SignUp().tag);
            },
            child: Text(
              'Registrate!',
              style: Theme.of(context).textTheme.subhead
            )
        )
      ],
    );
  }


  /*
   * Texto para recuperar contraseña
   * 
   * @return [Widget]
   */
  Widget _textRecoverPassword()
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pushNamed(context, RecoverPassword().tag);
          },
          child: Text(
            'Recuperar contraseña',
            style: Theme.of(context).textTheme.body1
          )
        )
      ],
    );
  }


  /*
  * Contenido de la vista
  *
  * @return [Widget] 
  */
  Widget _buidlWidget() 
  {
    return Container(
        child: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 9),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Text('Respikaf', style: Theme.of(context).textTheme.title),
                    SizedBox(height: SizeConfig.blockSizeVertical * 10),
                    InputText(
                      label: 'Correo',
                      typeInput: TextInputType.emailAddress,
                      controller: ctrlEmail
                    ),


                    SizedBox(height: SizeConfig.blockSizeVertical * 3.5),
                    InputText(
                      controller: ctrlPassword,
                      label: 'Contraseña',
                      typeInput: TextInputType.text,
                      isPassword: true,
                    ),

                    
                    SizedBox(height: SizeConfig.blockSizeVertical * 7),
                    RaisedButton(
                      elevation: 6,
                      onPressed: _validateAndSave,
                      child: Text(
                        'Ingresar',
                        style: Theme.of(context).textTheme.display1
                      ),
                    ),


                    SizedBox(height: SizeConfig.blockSizeVertical * 5),
                    _textRegister(),
                    
                    _textRecoverPassword(),
                  ],
                ),
              )),
        ));
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
          child: _buidlWidget(),
          inAsyncCall: _isLoading,
          opacity: 0.4,
          color: Colors.black
        )
      );
  }
}
