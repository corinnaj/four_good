import 'package:flutter/material.dart';
import 'overview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VolunteeredScreen extends StatefulWidget {
  final Project project;

  const VolunteeredScreen({Key key, this.project}) : super(key: key);

  @override
  _VolunteeredScreenState createState() => _VolunteeredScreenState();
}

class _VolunteeredScreenState extends State<VolunteeredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(color: Colors.indigoAccent),
              child: Text('Successfully volunteered',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.white)),
            ),
            Center(
                child: FlatButton.icon(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  label: Text('Back to overview'),
                  icon: const Icon(FontAwesomeIcons.tasks, size: 18.0),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop()
                  },
              splashColor: Colors.redAccent,
            ))
          ],
        ),
      ),
    );
  }
}
