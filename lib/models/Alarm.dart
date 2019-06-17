class Alarm 
{
	final String name, hour;
	bool state = true;

	Alarm({this.name, this.hour, this.state});


	Alarm.fromJson(Map<String, dynamic> json)
		: name = json['name'],
		  hour = json['hour'],
		  state = json['state'];


	Map<String, dynamic> toJson() => 
	{
		'name' : name,
		'hour' : hour,
		'state': state
	};
}