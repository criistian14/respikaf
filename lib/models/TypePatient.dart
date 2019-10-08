class TypePatient {
  int id;
	String type;

	TypePatient({ this.id, this.type });


  
	factory TypePatient.fromJson(Map<String, dynamic> json)
	{
		return TypePatient(
			id: json['id'] as int ?? 0,
			type: json['type'] as String ?? ''
		);
	}

}