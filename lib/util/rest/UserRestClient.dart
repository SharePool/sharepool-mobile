import 'package:share_pool/model/dto/LoginUserDto.dart';
import 'package:share_pool/model/dto/RegisterUserDto.dart';

abstract class UserRestClient {
  Future<String> registerUser(RegisterUserDto registerUserDto);

  Future<String> loginUser(LoginUserDto loginUserDto);
}
