import 'package:flutter/material.dart';
import 'overview.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'volunteered_screen.dart';

class ProjectDetailView extends StatefulWidget {
  final Project project;

  const ProjectDetailView({Key key, this.project}) : super(key: key);

  @override
  _ProjectDetailViewState createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> {
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
            Image.network(widget.project.picture),
            if (widget.project.isExternal)
              Container(
                decoration: new BoxDecoration(color: Colors.indigoAccent),
                child: Text(widget.project.website,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white)),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Text(
                widget.project.description,
                style: Theme.of(context).textTheme.body1.copyWith(fontSize: 18),
              )),
            ),
            if (widget.project.time != null && widget.project.regularly)
              Center(
                  child: Text(DateFormat('kk:mm EEE, ')
                      .format(widget.project.time) + 'regularly')),
            if (widget.project.time != null && !widget.project.regularly)
              Center(
                  child: Text(DateFormat('kk:mm EEE, d MMM yyyy')
                      .format(widget.project.time))),
            if (widget.project.geoPoint != null)
              Container(width: 200, height: 200, child: _buildMap(context)),
            if (!widget.project.isExternal)
              Center(
                  child: FlatButton.icon(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: Text("Do it 4 Good"),
                icon: const Icon(FontAwesomeIcons.handHoldingHeart, size: 18.0),
                onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              VolunteeredScreen(project: widget.project)))
                    },
                splashColor: Colors.redAccent,
              ))
            else
              Center(
                  child: FlatButton.icon(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: Text('Visit external website'),
                icon: const Icon(FontAwesomeIcons.link, size: 18.0),
                onPressed: () => {launch(widget.project.source_url)},
                splashColor: Colors.redAccent,
              ))
          ],
        ),
      ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return FlutterMap(
        options: new MapOptions(
          center: LatLng(widget.project.geoPoint.latitude,
              widget.project.geoPoint.longitude),
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
                point: new LatLng(widget.project.geoPoint.latitude,
                    widget.project.geoPoint.longitude),
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
