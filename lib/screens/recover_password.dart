import 'package:flutter/material.dart';

// Libraries
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Utilities
import 'package:respikaf/common/size_config.dart';

// Widgets Custom
import 'package:respikaf/components/InputText.dart';

// Services
import 'package:respikaf/services/UserService.dart';

// Screens
import 'package:respikaf/screens/login.dart';



class RecoverPassword extends StatefulWidget 
{
  final String tag = 'recover_password';


  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> 
{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextEditingController ctrlEmail = TextEditingController();


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
      };

      var response = await UserService().recoverPassword(data: data);


      setState(() {
        _isLoading = false;
      });

      if (response["status"] == "success") {

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
            backgroundColor: Colors.red[800]));
      } 

    } else {
      print('Form is invalid');
    }
  }



  /*
  * Contenido de la vista
  *
  * @return [Widget] 
  */
  Widget _buidlWidget() 
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 8),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 10),
            child: Text('Respikaf', style: Theme.of(context).textTheme.title),
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * 10),
          Text('Por favor ingresa tu email para buscar tu cuenta.', style: Theme.of(context).textTheme.body1),

          SizedBox(height: SizeConfig.blockSizeVertical * 4),
          Form(
            key: formKey,
            child: InputText(label: 'Correo', typeInput: TextInputType.emailAddress, controller: ctrlEmail)
          ),

          SizedBox(height: SizeConfig.blockSizeVertical * 4),
          RaisedButton(
            elevation: 6,
            onPressed: _validateAndSave,
            child: Text(
              'Recuperar',
              style: Theme.of(context).textTheme.display1
            ),
          ),

        ],
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
        elevation: 0,
      ),
      body: ModalProgressHUD(
        child: _buidlWidget(),
        inAsyncCall: _isLoading,
        opacity: 0.4,
        color: Colors.black
      )
    );
  }
}