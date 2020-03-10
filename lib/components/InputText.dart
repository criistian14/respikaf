import 'package:flutter/material.dart';


class InputText extends StatefulWidget
{
	final String label, value;
	final TextInputType typeInput;
	final bool isPassword;
	final Function(String) setValue;
  final TextEditingController controller;
  final bool isRequired;


	InputText({
    @required this.label, 
    @required this.typeInput, 
    this.isPassword, 
    this.setValue, 
    this.value, 
    this.controller,
    this.isRequired = true
  });

	_InputTextState createState() => _InputTextState();
}


class _InputTextState extends State<InputText>
{
	bool _isFocus = false;
	double _height = 1;
	FocusNode _inputFocus = FocusNode();
	String text = '';
	TextEditingController _controller = TextEditingController();


  /*
   * Cambia el valor del campo, por un evento o por si es enviado como parametro 
   */
	void changeText()
	{
		setState(() => text = _controller.text);
	}


  /*
   *  Valida si el campo esta vacio y devuelve el mensaje de error
   * 
   * @return [String]  
   */
	String _validateEmpty(String value)
	{
		return value.isEmpty ? 'Es obligatorio' : null;
	}



  /*
  * Renderiza toda la vista
  *
  * @return [Widget] 
  */
	@override
	Widget build(BuildContext context)
	{
    // Comprobar si se fue enviado un controlador o una funcion para cambiar el valor 
    if(widget.controller == null) {
      if (widget.value != null) {
        _controller.text = widget.value;
        changeText();

      } else {

        _controller.addListener(changeText);
      }
    }


    // Comprobar si tiene el focus para cambiar el label
		_inputFocus.addListener(() {
			setState(() {
				if (_inputFocus.hasFocus) {
					_isFocus = true; 
					_height = 0.6;  
				} else {

					if (text.isEmpty) {
						_isFocus = false;
						//_height = 3;
						_height = 1;
					}
				}
			});	
		});



		return( TextFormField(
			keyboardType: widget.typeInput,
			obscureText: (widget.isPassword == null ? false : widget.isPassword),
			focusNode: _inputFocus,
			validator: widget.isRequired ? _validateEmpty : null,
			controller: widget.controller != null ? widget.controller : _controller,
			onSaved: widget.setValue,
			style: TextStyle(color: Colors.white, fontSize: 20),
			decoration: InputDecoration(
				labelText: widget.label,
				labelStyle: TextStyle(
								color: (_isFocus ? Colors.white : Colors.grey[600]), 
								fontSize: 18, 
								fontFamily: 'Roboto',
								height: _height
							),
				errorStyle: TextStyle( fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red[300] ),
				errorBorder: OutlineInputBorder(borderSide: BorderSide(
					color: Colors.red[300]
				)),
				focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(
					color: Colors.red[300]
				)),
				focusedBorder: OutlineInputBorder(borderSide: BorderSide(
					color: Colors.white,
					width: 2
				)),
				enabledBorder: OutlineInputBorder(borderSide: BorderSide(
					color: Colors.white30,
					width: 2
				))
			),
		));
	}
}