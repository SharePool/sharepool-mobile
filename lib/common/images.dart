import 'dart:convert';

import 'package:flutter/material.dart';

Widget showProfileImage(String profileImg, [double radius]) {
  if (profileImg != null && profileImg.length > 0) {
    return Center(
      child: CircleAvatar(
        radius: radius ?? 80,
        backgroundImage: MemoryImage(base64Decode(profileImg)),
      ),
    );
  } else {
    return Center(
      child: CircleAvatar(
        radius: radius ?? 80,
        backgroundImage: AssetImage("assets/profile_img_placeholder.png"),
      ),
    );
  }
}
