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

        return buildListView(context, snapshot.data.documents);
      },
    );
  }

  ListView buildListView(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      children: snapshot.map((data) => buildListItem(context, data)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final project = Project.fromSnapshot(data);

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProjectDetailView(project: project))),
        child: Card(
          child: Container(
            height: 150.0,
            decoration: new BoxDecoration(
              border: project.isExternal ? Border.all(color: Colors.blueAccent, width: 4.2) : null),
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
  final bool isExternal;
  final String website;

  Project.fromMap(Map<String, dynamic> map)
      :assert(map['title'] != null),
        title = map['title'],
        address = map['address'],
        description = map['description'],
        picture = map['picture'],
        geoPoint = map['place'],
        isExternal = map['isExternal'],
        website = map['website'];

  Project.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

}
