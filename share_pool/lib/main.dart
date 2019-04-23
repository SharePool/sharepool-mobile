import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharePool',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DriverPage(),
    );
  }
}

class DriverPage extends StatefulWidget {
  DriverPage({Key key}) : super(key: key);

  final String title = "Driver";

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
    );
  }
}

class PassengerPage extends StatefulWidget {
  PassengerPage({Key key}) : super(key: key);

  final String title = "Passenger";

  @override
  _PassengerPageState createState() => _PassengerPageState();
}

class _PassengerPageState extends State<PassengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  final String title = "Settings";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Geanik"),
            accountEmail: Text("geanik@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://store.playstation.com/store/api/chihiro/00_09_000/container/US/en/999/UP0151-CUSA09971_00-AV00000000000001/1553247430000/image?w=240&h=240&bg_color=000000&opacity=100&_version=00_09_000"),
            ),
          ),
          ListTile(
            title: Text("Driver"),
            trailing: Icon(Icons.time_to_leave),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DriverPage()));
            },
          ),
          ListTile(
            title: Text("Passenger"),
            trailing: Icon(Icons.thumb_up),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PassengerPage()));
            },
          ),
          ListTile(
            title: Text("Settings"),
            trailing: Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
