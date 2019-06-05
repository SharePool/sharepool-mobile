import 'package:flutter/material.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchTourWidget extends StatelessWidget {
  List<TourDto> tours;

  Future<void> loadTours() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    List<TourDto> tours = await TourRestClient.getToursForUser(
        sharedPreferences.getInt(Constants.SETTINGS_USER_ID));

    this.tours = tours;
  }

  @override
  void initState() {
    loadTours();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      TextField(
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))
          ),
      ),
    ]);
  }
}
