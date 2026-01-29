class SignupInput {
  String? username;
  String? email;
  String? codeAreaId;
  String? password;
  String? name;
  String? lastname;
  String? birthdate;
  String? gender;
  String? phoneNumber;
  String? countryId; // Assuming countryId is an integer
  String? city;
  String? state;
  String? identifier;
  bool? isBaptized;

  SignupInput({
    this.username,
    this.email,
    this.codeAreaId,
    this.password,
    this.name,
    this.lastname,
    this.birthdate,
    this.gender,
    this.phoneNumber,
    this.countryId,
    this.city,
    this.state,
    this.identifier,
    this.isBaptized,
  });

  // Factory constructor to create an SignupInput object from a JSON map
  factory SignupInput.fromJson(Map<String, dynamic> json) => SignupInput(
        username: json['username'],
        email: json['email'],
        codeAreaId: json['codeAreaId'],
        password: json['password'],
        name: json['name'],
        lastname: json['lastname'],
        birthdate: json['birthdate'],
        gender: json['gender'],
        phoneNumber: json['phoneNumber'],
        countryId: json['countryId'], // Parse countryId as int
        city: json['city'],
        state: json['city'],
        identifier: json['identifier'],
        isBaptized: json['isBaptized'],
      );

  // Method to convert an SignupInput object to a JSON map
  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'codeAreaId': codeAreaId,
        'password': password,
        'name': name,
        'lastname': lastname,
        'birthdate': birthdate,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'countryId': countryId,
        'city': city,
        'state': state,
        'identifier': identifier,
        'isBaptized': isBaptized,
      };

  // A convenient method to print the object's values (for debugging)
  @override
  String toString() {
    return 'SignupInput{username: $username, email: $email, codeAreaId: $codeAreaId, password: $password, name: $name, lastname: $lastname, birthdate: $birthdate, gender: $gender, phoneNumber: $phoneNumber, countryId: $countryId, city: $city, state: $state, identifier: $identifier, isBaptized: $isBaptized}';
  }
}
