import 'package:flutter/material.dart';

// Libraries
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// Widgets Custom
import 'package:respikaf/widgets/InputText.dart';

// Screens
import 'package:respikaf/screens/home.dart';
import 'package:respikaf/screens/signup.dart';

class Login extends StatefulWidget {
  final String tag = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  final formKey = GlobalKey<FormState>();
  final url = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  TextEditingController ctrlEmail = TextEditingController(), ctrlPassword = TextEditingController();

  void _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _isLoading = true;
      });

      form.save();


      


      new Future.delayed(Duration(seconds: 2), () async {
        setState(() {
          _isLoading = false;
        });

        final prefs = await SharedPreferences.getInstance();

        prefs.setString('token', email);

        // Navigator.of(context).pushReplacementNamed(Home().tag);
      });
    } else {
      print('Form is invalid');
    }
  }

  Widget _buidlWidget() {
    return Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Text('Respikaf', style: Theme.of(context).textTheme.title),
                    SizedBox(height: 48),
                    InputText(
                        label: 'Correo',
                        typeInput: TextInputType.emailAddress,
                        controller: ctrlEmail),
                    SizedBox(height: 22),
                    InputText(
                      controller: ctrlPassword,
                      label: 'Contraseña',
                      typeInput: TextInputType.text,
                      isPassword: true,
                    ),
                    SizedBox(height: 50),
                    RaisedButton(
                      elevation: 6,
                      onPressed: _validateAndSave,
                      child: Text('Ingresar',
                          style: Theme.of(context).textTheme.display1),
                    ),
                    SizedBox(height: 38),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('¿Aun no tienes cuenta?',
                            style: Theme.of(context).textTheme.body1),
                        SizedBox(width: 10),
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {
                              Navigator.pushNamed(context, SignUp().tag);
                            },
                            child: Text('Registrate!',
                                style: Theme.of(context).textTheme.subhead))
                      ],
                    )
                  ],
                ),
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: ModalProgressHUD(
            child: _buidlWidget(),
            inAsyncCall: _isLoading,
            opacity: 0.4,
            color: Colors.black));
  }
}
