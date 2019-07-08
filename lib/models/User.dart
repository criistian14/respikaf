class User {
	String firstName, lastName, phone, email, password, typePacient;
	int age;

	User({ this.firstName, this.lastName, this.phone, this.email, this.password, this.age, this.typePacient });


	factory User.fromJson(Map<String, dynamic> json)
	{
		return User(
			firstName: json['firstname'] as String,
			lastName: json['lastname'] as String,
			email: json['email'] as String,
			password: json['password'] as String,
			age: json['age'] as int,
			typePacient: json['tipo'] as String
		);
	}

	Map<String, dynamic> toJson() => 
	{
		'firstname': firstName,
		'lastname': lastName,
		'email': email,
		'password': password,
		'age': age,
		'tipo': typePacient
	};
}