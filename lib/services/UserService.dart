import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class UserService {

	final String _baseUrl = 'https://respikaf.herokuapp.com/api';
  final Map<String, String> _headers = {
    'Content-type' : 'application/json',
    "Accept": "application/json"
  };

	Future<dynamic> create({ Map data }) async
	{
		http.Response response = await http.post("$_baseUrl/auth/signup", body: jsonEncode(data), headers: _headers);

		return jsonDecode(response.body);
	}


	Future<dynamic> login({ Map data }) async
	{
		http.Response response = await http.post("$_baseUrl/auth/login", body: jsonEncode(data), headers: _headers);

		return jsonDecode(response.body);
	}

}