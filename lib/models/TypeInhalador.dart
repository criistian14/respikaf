class TypeInhalador {
  int id, dose, micrograms, typePatientId;
	String name;
  bool adult;

	TypeInhalador({ this.id, this.dose, this.micrograms, this.typePatientId, this.name, this.adult });


  
	factory TypeInhalador.fromJson(Map<String, dynamic> json)
	{
		return TypeInhalador(
			id: json['id'] as int ?? 0,
			dose: json['dose'] as int ?? 0,
			micrograms: json['micrograms'] as int ?? 0,
			typePatientId: json['type_patient_id'] as int ?? 0,
			name: json['name'] as String ?? '',
			adult: json['adult'] as bool ?? true,
		);
	}

}