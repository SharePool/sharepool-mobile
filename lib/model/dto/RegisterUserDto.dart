class RegisterUserDto {
  String firstName;
  String lastName;
  String username;
  String email;
  String password;

  RegisterUserDto(this.firstName, this.lastName, this.username, this.email,
      this.password);

  RegisterUserDto.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        username = json['userName'],
        email = json['email'],
        password = json['password'];

  dynamic toJson() =>
      {
        'firstName': firstName,
        'lastName': lastName,
        'userName': username,
        'email': email,
        'password': password
      };
}
