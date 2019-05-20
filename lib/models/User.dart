class User {
	String name, lastName, phone, email, password, typePacient;
	int years;

	User({ this.name, this.lastName, this.phone, this.email, this.password, this.years, this.typePacient });


	factory User.fromJson(Map<String, dynamic> json)
	{
		return User(
			name: json['name'] as String,
			lastName: json['lastName'] as String,
			email: json['email'] as String,
			password: json['password'] as String,
			years: json['years'] as int,
			typePacient: json['years'] as String
		);
	}
}