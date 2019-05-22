import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HttpHandler {

	final String _baseUrl = 'https://respikaf-v1.herokuapp.com/api';

	Future<dynamic> getJson(String url) async
	{
		http.Response response = await http.get(_baseUrl + url);

		return jsonDecode(response.body);
	}


	Future<dynamic> post(String url, Map body) async
	{
		http.Response response = await http.post(_baseUrl + url, body: body);

		return jsonDecode(response.body);
	}
}