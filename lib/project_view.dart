import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'overview.dart';

class ProjectDetailView extends StatefulWidget {
  final DocumentSnapshot projectDocument;

  ProjectDetailView({Key key, this.projectDocument}) : super(key: key);

  @override
  _ProjectDetailViewState createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  bool ismyproject = false;
  BuildContext innerContext;

  void _doIt(BuildContext context, DocumentReference projectReference) {
    setState(() {
      ismyproject = true;
    });
    projectReference.updateData({'ismyproject': true});
  }

  void _cancelIt(BuildContext context, DocumentReference projectReference) {
    setState(() {
      ismyproject = false;
    });
    projectReference.updateData({'ismyproject': false});
  }

  @override
  Widget build(BuildContext context) {
    final project = Project.fromSnapshot(widget.projectDocument);
    setState(() {
      ismyproject = widget.projectDocument.data['ismyproject'];
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(project.picture),
            if (project.isExternal)
              Container(
                decoration: new BoxDecoration(color: Colors.indigoAccent),
                child: Text(project.website,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white)),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                project.description,
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 18),
              )),
            ),
            if (project.time != null)
              Center(
                  child: Text(DateFormat('kk:mm EEE, d MMM yyyy')
                      .format(project.time))),
            if (project.geoPoint != null)
              Container(
                  width: 200, height: 200, child: _buildMap(context, project)),
            if (ismyproject == null || !ismyproject)
              Center(
                  child: FlatButton.icon(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: Text("Do it 4 Good"),
                icon: const Icon(FontAwesomeIcons.handHoldingHeart, size: 18.0),
                onPressed: () {
                  _doIt(context, widget.projectDocument.reference);
                },
                splashColor: Colors.redAccent,
              ))
            else
              Center(
                  child: FlatButton.icon(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: Text("Can't made it anymore"),
                icon: const Icon(FontAwesomeIcons.sadTear, size: 18.0),
                onPressed: () {
                  _cancelIt(context, widget.projectDocument.reference);
                },
                splashColor: Colors.redAccent,
              )),
            if (project.isExternal)
              Center(
                  child: FlatButton.icon(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: Text('Visit external website'),
                icon: const Icon(FontAwesomeIcons.link, size: 18.0),
                onPressed: () => {launch(project.source_url)},
                splashColor: Colors.redAccent,
              ))
          ],
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context, Project project) {
    return FlutterMap(
        options: new MapOptions(
          center: LatLng(project.geoPoint.latitude, project.geoPoint.longitude),
          zoom: 13.0,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          new MarkerLayerOptions(
            markers: [
              new Marker(
                width: 80.0,
                height: 80.0,
                point: new LatLng(
                    project.geoPoint.latitude, project.geoPoint.longitude),
                builder: (ctx) => new Container(
                      child: const Icon(
                        FontAwesomeIcons.mapMarkerAlt,
                        size: 50.0,
                        color: Colors.black,
                      ),
                    ),
              ),
            ],
          )
        ]);
  }
}
