import 'dart:convert';

import 'package:flutter/material.dart';

Widget showProfileImage(String profileImg, double height) {
  if (profileImg != null && profileImg.length > 0) {
    return Image.memory(
      base64Decode(profileImg),
      height: height,
    );
  } else {
    return Image.asset(
      'assets/profile_img_placeholder.png',
      height: height,
    );
  }
}
