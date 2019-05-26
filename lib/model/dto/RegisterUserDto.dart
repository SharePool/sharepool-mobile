class RegisterUserDto {
  String firstName;
  String lastName;
  String email;
  String password;

  RegisterUserDto(this.firstName, this.lastName, this.email, this.password);

  RegisterUserDto.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        password = json['password'];

  dynamic toJson() =>
      {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password
      };
}
