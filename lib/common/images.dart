import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';

Widget showProfileImage(UserDto user, double height) {
  if (user.profileImg != null && user.profileImg.length > 0) {
    return Image.memory(
      base64Decode(user.profileImg),
      height: height,
    );
  } else {
    return Image.asset(
      'assets/profile_img_placeholder.png',
      height: height,
    );
  }
}
