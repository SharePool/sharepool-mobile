class UserDto {
  String firstName;
  String lastName;
  String userName;

  UserDto(this.firstName, this.lastName, this.userName);

  UserDto.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'],
        lastName = json['lastName'],
        userName = json['userName'];

  dynamic toJson() =>
      {'firstName': firstName, 'lastName': lastName, 'userName': userName};
}
