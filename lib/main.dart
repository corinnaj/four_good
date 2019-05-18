import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_good/backdrop.dart';
import 'package:four_good/backdrop_content.dart';
import 'package:four_good/filter_options.dart';
import 'package:four_good/overview.dart';
import 'package:four_good/profile.dart';
import 'package:rxdart/rxdart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child),
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
  BehaviorSubject<MyFilterOptions> filterOptionsController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );

		filterOptionsController = BehaviorSubject<MyFilterOptions>.seeded(MyFilterOptions(''));
  }

  @override
  void dispose() {
  	filterOptionsController.close();
  	super.dispose();
	}

  List<DocumentSnapshot> _filterDocuments(AsyncSnapshot snapshot) {
  	return snapshot.data.documents;
	}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                  underHeaderTitle: '',//'x Projects Found',
                  //frontLayer: ProjectOverview(filterOptionsController.stream),
									frontLayer: ProjectOverview(),
                  frontTitle: Text('4 Good'),
                  //backLayer: BackdropContent(filterOptionsController.sink),
									backLayer: BackdropContent(),
                  backTitle: Text('Filter Projects'),
                  controller: _controller,
                ),
        );
  }
}
