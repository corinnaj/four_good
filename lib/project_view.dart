import 'package:flutter/material.dart';

class ProjectDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Title'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.network(
              'http://pangea-projekt.de/wordpress/wp-content/uploads/2016/10/Deutschkurs_2-1230x820.jpg'),
          Center(
            child: RaisedButton(
              child: Text('Do it 4 Good!'),
            ),
          )
        ],
      ),
    );
  }
}
