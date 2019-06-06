class UserDto {
  String firstName;
  String lastName;
  String userName;
  String email;
  String password;

  UserDto({this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.password});

  UserDto.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        userName = json['userName'],
        email = json['email'],
        password = json['password'];

  dynamic toJson() =>
      {
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'email': email,
        'password': password
      };
}
