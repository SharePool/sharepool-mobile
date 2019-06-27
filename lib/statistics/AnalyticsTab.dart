import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_pool/model/dto/analytics/AnalyticsEntry.dart';
import 'package:share_pool/util/rest/AnalyticsRestClient.dart';

class AnalyticsTab extends StatefulWidget {
  AnalyticsTab({Key key}) : super(key: key);

  @override
  _AnalyticsTabState createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  List<Series<AnalyticsEntry, DateTime>> seriesList;

  DateTime from = DateTime.now().subtract(Duration(days: 7));
  DateTime to = DateTime.now();

  var dateFormatter = new DateFormat('yyyy-MM-dd');
  Widget chart = Text("No data");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              child: Text(dateFormatter.format(from)),
              onPressed: () async {
                var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: from,
                    firstDate: DateTime(2019, 1),
                    lastDate: DateTime.now());

                if (selectedDate != null && selectedDate != from) {
                  setState(() {
                    from = selectedDate;
                    loadAnalyticsData();
                  });
                }
              },
            ),
            Spacer(),
            FlatButton(
              child: Text(dateFormatter.format(to)),
              onPressed: () async {
                var selectedDate = await showDatePicker(
                    context: context,
                    initialDate: to,
                    firstDate: DateTime(2019, 1),
                    lastDate: DateTime.now().add(Duration(days: 1)));

                if (selectedDate != null && selectedDate != to) {
                  setState(() {
                    to = selectedDate;
                    loadAnalyticsData();
                  });
                }
              },
            )
          ],
        ),
        Flexible(
            child: Padding(padding: const EdgeInsets.all(30.0), child: chart))
      ],
    );
  }

  @override
  void initState() {
    loadAnalyticsData();
  }

  Future loadAnalyticsData() async {
    var analyticsData =
        await AnalyticsRestClient.getAnalyticsDataForTimeSpan(from, to);

    setState(() {
      seriesList = [
        new Series<AnalyticsEntry, DateTime>(
            id: "km",
            colorFn: (AnalyticsEntry entry, _) =>
                MaterialPalette.blue.shadeDefault,
            domainFn: (AnalyticsEntry entry, _) => entry.creationDate,
            measureFn: (AnalyticsEntry entry, _) => entry.kmSum,
            data: analyticsData.values.toList()),
        new Series<AnalyticsEntry, DateTime>(
            id: "gas saved",
            colorFn: (AnalyticsEntry entry, _) =>
                MaterialPalette.lime.shadeDefault,
            domainFn: (AnalyticsEntry entry, _) => entry.creationDate,
            measureFn: (AnalyticsEntry entry, _) => entry.litersGasSaved,
            data: analyticsData.values.toList())
      ];

      chart = TimeSeriesChart(
        seriesList,
        animate: true,
        dateTimeFactory: const LocalDateTimeFactory(),
        defaultRenderer: new BarRendererConfig<DateTime>(),
        behaviors: [
          SeriesLegend(
            position: BehaviorPosition.top,
          )
        ],
      );
    });
  }
}
