import 'package:flutter/material.dart';
import 'package:four_good/backdrop.dart';
import 'package:four_good/backdrop_content.dart';
import 'package:four_good/overview.dart';
import 'package:four_good/profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.indigo, accentColor: Colors.amberAccent),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: AppBar(
        //  title: Text('4 Good'),
        //),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(),
                ),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
              ListTile(
                title: Text('My Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              )
            ],
          ),
        ),
        body: Backdrop(
          frontLayer: ProjectOverview(),
          frontTitle: Text('4 Good'),
          backLayer: BackdropContent(),
          backTitle: Text('Filter Projects'),
          controller: _controller,
        ));
  }
}

