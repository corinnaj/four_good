import 'package:flutter/material.dart';
import 'overview.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectDetailView extends StatefulWidget {
  final DocumentSnapshot projectDocument;

  const ProjectDetailView({Key key, this.projectDocument}) : super(key: key);

  @override
  _ProjectDetailViewState createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
  Widget _buildDate(Project project) {
    return project.time != null
        ? Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Icon(
                Icons.calendar_today,
                size: 30.0,
              ),
            ),
            Text(
              DateFormat('EEE, d MMM yyyy kk:mm').format(project.time),
              style: Theme.of(context).textTheme.title,
            )
          ])
        : Container();
	}

  bool ismyproject = false;

  @override
  void initState() {
    super.initState();
    ismyproject = widget.projectDocument.data['ismyproject'];
  }

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
    Project project = Project.fromSnapshot(widget.projectDocument);
    return Scaffold(
      appBar: AppBar(
        title: Text(project.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share('check out my website https://example.com');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.network(project.picture),
            _buildDate(project),
            if (project.isExternal)
              Container(
                decoration: new BoxDecoration(color: Colors.indigoAccent),
                child: Text(project.website,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white)),
              ),
            if (project.categories != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      direction: Axis.horizontal,
                      children: project.categories
                          .map((category) => BubbleItem(category, Colors.green))
                          .toList()),
                ),
              ),
            if (project.neededSkills != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Wrap(
                      spacing: 1.0,
                      runSpacing: 1.0,
                      direction: Axis.horizontal,
                      children: project.neededSkills
                          .map((neededSkill) =>
                              BubbleItem(neededSkill.documentID, Colors.orange))
                          .toList()),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                  child: Text(
                project.description.replaceAll('\\n', '\n\n'),
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 14),
              )),
            ),
            SizedBox(height: 12.0),
            if (project.geoPoint != null)
              Container(width: 200, height: 200, child: _buildMap(context, project)),
            if (project.time != null && project.regularly)
              Center(
                  child: Text(DateFormat('kk:mm EEE, ').format(project.time) +
                      'regularly')),
            if (!ismyproject)
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
                label: Text("Can't make it anymore"),
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

class BubbleItem extends StatefulWidget {
  final String text;
  final Color bubbleColor;

  const BubbleItem(this.text, this.bubbleColor);

  @override
  _BubbleItemState createState() => _BubbleItemState();
}

class _BubbleItemState extends State<BubbleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.bubbleColor, borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.text,
            style: Theme.of(context)
                .textTheme
                .body1
                .copyWith(color: Colors.white)),
      ),
    );
  }
}
