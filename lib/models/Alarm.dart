import 'package:flutter/material.dart';

class Alarm 
{
	final String name, hour;
	bool state = true;
	TimeOfDay time;

	Alarm({this.name, this.hour, this.time, this.state});


	Alarm.fromJson(Map<String, dynamic> json)
		: name = json['name'],
		  hour = json['hour'],
		  time = json['time'],
		  state = json['state'];


	Map<String, dynamic> toJson() => 
	{
		'name' : name,
		'hour' : hour,
		'time' : time,
		'state': state
	};
}