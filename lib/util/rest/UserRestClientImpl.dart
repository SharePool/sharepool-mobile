import 'package:share_pool/model/dto/LoginUserDto.dart';
import 'package:share_pool/model/dto/RegisterUserDto.dart';
import 'UserRestClient.dart';

class UserRestClientImpl implements UserRestClient {
  @override
  String loginUser(LoginUserDto loginUserDto) {
    // TODO: implement loginUser
    if (loginUserDto.email != null && loginUserDto.password != null) {
      return "sd87f98s79f";
    }

    return null;
  }

  @override
  String registerUser(RegisterUserDto registerUserDto) {
    // TODO: implement registerUser
    return null;
  }
}
