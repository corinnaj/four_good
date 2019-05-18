import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Personal Information',
                  style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                childAspectRatio: 7,
                crossAxisCount: 2,
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  GridTile(
                      child: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  GridTile(child: Text('Eva Krebs')),
                  GridTile(
                      child: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  GridTile(child: Text('eveisevil@evil.com')),
                  GridTile(
                      child: Text(
                    'City',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  GridTile(child: Text('Berlin')),
                ],
              ),
            ),
						Padding(
							padding: const EdgeInsets.all(8.0),
							child: Text('Skills',
								style: Theme.of(context).textTheme.title),
						),
            Slider(min: 0, value: 5, max: 10)
          ],
        ),
      ),
    );
  }
}
