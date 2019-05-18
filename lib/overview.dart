import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_good/filter_options.dart';
import 'package:four_good/project_view.dart';
import 'package:rxdart/rxdart.dart';

class ProjectOverview extends StatefulWidget {
	//final Observable<MyFilterOptions> optionStream;

	//ProjectOverview(this.optionStream);
	ProjectOverview();

  @override
  _ProjectOverviewState createState() => _ProjectOverviewState();
}

class _ProjectOverviewState extends State<ProjectOverview> {
	Stream<QuerySnapshot> answerStream;

	@override
  void initState() {
    super.initState();

//		answerStream = widget.optionStream.flatMap((options) {
//			print('asdfasdfasdf');
//		  return Firestore.instance
//			.collection('Projects')
//			//.where('isExternal', isEqualTo: false)
//			//.where('terms', arrayContains: options.keyWords)
//			.snapshots();
//		});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      //stream: answerStream,
			stream: Firestore.instance.collection('Projects').snapshots(),
      builder: (context, snapshot) {
      	print(snapshot);
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
  final String source_url;
  final DateTime time;
  final bool regularly;

  Project.fromMap(Map<String, dynamic> map)
      :assert(map['title'] != null),
        title = map['title'],
        address = map['address'],
        description = map['description'],
        picture = map['picture'],
        geoPoint = map['place'],
        isExternal = map['isExternal'],
        website = map['website'],
        source_url = map['source_url'],
        time = map['time'],
        regularly = map['regularly'];


  Project.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

}
