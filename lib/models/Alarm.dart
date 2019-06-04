class Alarm 
{
	final String name, hour;

	Alarm({this.name, this.hour});


	Alarm.fromJson(Map<String, dynamic> json)
		: name = json['name'],
		  hour = json['hour'];


	Map<String, dynamic> toJson() => 
	{
		'name': name,
		'hour': hour
	};
}