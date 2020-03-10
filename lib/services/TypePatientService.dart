import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TypePatientService {

	final String _baseUrl = 'https://respikaf.herokuapp.com/api/type_patient';
  final Map<String, String> _headers = {
    'Content-type' : 'application/json',
    "Accept": "application/json"
  };

	Future<dynamic> getAll() async
	{
		http.Response response = await http.get("$_baseUrl", headers: _headers);

		return jsonDecode(response.body);
	}
}