import 'package:flutter/material.dart';
import 'package:four_good/overview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('4 Good'),
      ),
      drawer: Drawer(
				child: Column(
					children: <Widget>[
					],
				),
			),
      body: ProjectOverview()
		);
  }
}
