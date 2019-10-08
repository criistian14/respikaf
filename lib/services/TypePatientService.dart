import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TypePatientService {

	final String _baseUrl = 'https://respikaf.herokuapp.com/api';
  final Map<String, String> _headers = {
    'Content-type' : 'application/json',
    "Accept": "application/json"
  };

	Future<dynamic> getAll() async
	{
		http.Response response = await http.get("$_baseUrl/type_patient", headers: _headers);

		return jsonDecode(response.body);
	}
}