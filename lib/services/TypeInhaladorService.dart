import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Libraries
import 'package:shared_preferences/shared_preferences.dart';


class TypeInhaladorService {

	final String _baseUrl = 'https://respikaf.herokuapp.com/api/type_inhalador';
  Map<String, String> _headers = {
    'Content-type' : 'application/json',
    "Accept": "application/json"
  };

	Future<dynamic> getForUser() async
	{
    final prefs = await SharedPreferences.getInstance();

    _headers['Authorization'] = prefs.getString('token1') + prefs.getString('token2');

		http.Response response = await http.get("$_baseUrl/user", headers: _headers);

		return jsonDecode(response.body);
	}

}