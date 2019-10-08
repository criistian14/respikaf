class User {
	String name, lastname, email, password, passwordConfirmation, phone, avatar;
	int id, age, currentDose, typePatientId, typeInhaladorId;

	User({ 
    this.id,
    this.name, 
    this.lastname, 
    this.email, 
    this.password, 
    this.passwordConfirmation,
    this.phone, 
    this.avatar, 
    this.age, 
    this.currentDose, 
    this.typePatientId, 
    this.typeInhaladorId,
  });


	factory User.fromJson(Map<String, dynamic> json)
	{
		return User(
			id: json['id'] as int ?? 0,
			name: json['name'] as String ?? '',
			lastname: json['lastname'] as String ?? '',
			email: json['email'] as String ?? '',
			password: json['password'] as String ?? '',
			phone: json['phone'] as String ?? '',
			avatar: json['avatar'] as String ?? '',
			age: json['age'] as int ?? 0,
			currentDose: json['current_dose'] as int ?? 0,
			typePatientId: json['type_patient_id'] as int ?? 1,
			typeInhaladorId: json['type_inhalador_id'] as int ?? 1,
		);
	}

	Map<String, dynamic> toJson() => 
	{
    'name': name,
    'lastname': lastname,
    'email': email,
    'password': password,
    'phone': phone,
    'age': age,
    'current_dose': currentDose,
    'type_patient_id': typePatientId,
    'type_inhalador_id': typeInhaladorId,
    'password_confirmation': passwordConfirmation,
	};
}