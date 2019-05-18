import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_good/project_view.dart';

class ProjectOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Projects').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildListView(context, snapshot.data.documents);
      },
    );
  }

  ListView _buildListView(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final project = Project.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProjectDetailView(project: project))),
        child: Card(
          child: Container(
            height: 150.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                    project.picture,
                    fit: BoxFit.cover),
                Positioned(
                    bottom: 10.0,
                    left: 10.0,
                    child: Text(project.title,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.white))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Project {
  final String title;
  final String address;
  final String description;
  final String picture;
  final GeoPoint geoPoint;

  Project.fromMap(Map<String, dynamic> map)
      :assert(map['title'] != null),
        title = map['title'],
        address = map['address'],
        description = map['description'],
        picture = map['picture'],
        geoPoint = map['place'];

  Project.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

}
