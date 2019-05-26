class LoginUserDto {
  String email;
  String password;

  LoginUserDto(this.email, this.password);

  LoginUserDto.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  dynamic toJson() => {'email': email, 'password': password};
}
