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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ProjectDetailView())),
        child: Card(
          child: Container(
            height: 150.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                    'http://pangea-projekt.de/wordpress/wp-content/uploads/2016/10/Deutschkurs_2-1230x820.jpg',
                    fit: BoxFit.cover),
                Positioned(
                    bottom: 10.0,
                    left: 10.0,
                    child: Text(data.data['title'],
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
