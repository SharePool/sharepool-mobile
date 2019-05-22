import 'package:share_pool/model/dto/LoginUserDto.dart';
import 'package:share_pool/model/dto/RegisterUserDto.dart';

abstract class UserRestClient {
  String registerUser(RegisterUserDto registerUserDto);

  String loginUser(LoginUserDto loginUserDto);
}
