import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:share_pool/driver-settings/dto/tourDto.dart';

class TourListWidget extends StatelessWidget {
  List<TourDto> tours;

  TourListWidget(this.tours);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: tours == null ? 0 : tours.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: new Text(tours[index].from),
          );
        });
  }
}
