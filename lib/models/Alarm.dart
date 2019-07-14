class Alarm 
{
	final String name, time;
	bool state = true;
	int hour, minute;

	Alarm({this.name, this.hour, this.minute, this.time, this.state});


	factory Alarm.fromJson(Map<String, dynamic> json)
	{
		return Alarm(
			name : json['name'] as String,
			hour : json['hour'] as int,
			minute : json['minute'] as int,
			time : json['time'] as String,
			state : json['state'] as bool
		);
	}


	Map<String, dynamic> toJson() => 
	{
		'name' : name,
		'hour' : hour,
		'minute' : minute,
		'time' : time,
		'state': state
	};
}