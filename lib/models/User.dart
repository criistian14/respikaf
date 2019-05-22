class User {
	String name, lastName, phone, email, password, typePacient;
	int age;

	User({ this.name, this.lastName, this.phone, this.email, this.password, this.age, this.typePacient });


	factory User.fromJson(Map<String, dynamic> json)
	{
		return User(
			name: json['name'] as String,
			lastName: json['lastName'] as String,
			email: json['email'] as String,
			password: json['password'] as String,
			age: json['age'] as int,
			typePacient: json['typePacient'] as String
		);
	}
}