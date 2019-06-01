class UserCredentialsDto {
  String userToken;
  int userId;

  UserCredentialsDto(this.userToken, this.userId);

  UserCredentialsDto.fromJson(Map<String, dynamic> json)
      : userToken = json["userToken"],
        userId = json["userId"];

  toJson() {
    return {
      "userToken": userToken,
      "userId": userId,
    };
  }
}
