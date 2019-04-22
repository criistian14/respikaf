import 'package:flutter/material.dart';


class InputText extends StatefulWidget
{
	final String label, value;
	final TextInputType typeInput;
	final bool isPassword;
	final Function(String) setValue;


	InputText({@required this.label, @required this.typeInput, this.isPassword, this.setValue, this.value});

	_InputTextState createState() => _InputTextState();
}


class _InputTextState extends State<InputText>
{
	bool _isFocus = false;
	double _height = 1;
	FocusNode _inputFocus = FocusNode();
	String text = '';
	TextEditingController _controller = TextEditingController();


	void changeText()
	{
		setState(() => text = _controller.text);
	}


	String _validateEmpty(String value)
	{
		return value.isEmpty ? 'Es obligatorio' : null;
	}




	@override
	Widget build(BuildContext context)
	{
		if (widget.value != null) {
			_controller.text = widget.value;
			changeText();

		} else {

			_controller.addListener(changeText);
		}


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
			validator: _validateEmpty,
			controller: _controller,
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