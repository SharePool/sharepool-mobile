class UserDto {
  String firstName;
  String lastName;
  String userName;
  String email;
  String password;
  String profileImg;
  double gasConsumption;

  UserDto(
      {this.firstName,
      this.lastName,
      this.userName,
      this.email,
      this.password,
      this.profileImg,
      this.gasConsumption});

  UserDto.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        userName = json['userName'],
        email = json['email'],
        password = json['password'],
        profileImg = json['profileImg'],
        gasConsumption = json['gasConsumption'];

  dynamic toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'userName': userName,
        'email': email,
        'password': password,
        'profileImg': profileImg,
        'gasConsumption': gasConsumption
      };
}
