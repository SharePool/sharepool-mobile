import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class GenerateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;

  GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _contentWidget();
  }

  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(
                top: _topSectionTopPadding,
                left: 20.0,
                right: 10.0,
                bottom: _topSectionBottomPadding,
              ),
              child: Text(
                "Title",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              )),
          Padding(
              padding: const EdgeInsets.only(
                top: _topSectionTopPadding,
                left: 20.0,
                right: 10.0,
                bottom: _topSectionBottomPadding,
              ),
              child: Text(
                  "Description: adjfn sdf sdfasf asdfasdf asdfsdf. sdfa sdfasd f oasjd fjo sdoj.")),
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: "qr data string",
                  size: 0.5 * bodyHeight,
                  onError: (ex) {
                    print("[QR] ERROR - $ex");
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
