class UserTokenDto {
  String userToken;

  UserTokenDto(this.userToken);

  UserTokenDto.fromJson(Map<String, dynamic> json)
      : userToken = json['userToken'];
}
