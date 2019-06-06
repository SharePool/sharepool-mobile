class UserLoginDto {
  String userNameOrEmail;
  String password;

  UserLoginDto(this.userNameOrEmail, this.password);

  UserLoginDto.fromJson(Map<String, dynamic> json)
      : userNameOrEmail = json['userNameOrEmail'],
        password = json['password'];

  dynamic toJson() =>
      {'userNameOrEmail': userNameOrEmail, 'password': password};
}
