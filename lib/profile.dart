import 'package:flutter/material.dart';
import 'overview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'project_view.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Personal Information',
                  style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MyProfileDataView(context),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Skills', style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MySkillsView(context),
            ),
            //Slider(min: 0, value: 5, max: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('My Projects:',
                  style: Theme.of(context).textTheme.title),
            ),
            Container(
                height: 1000, // Dummy Value
                child: MyProjectOverview()),
          ],
        ),
      ),
    );
  }

  Widget MyProfileDataView(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildFields(context, snapshot.data.documents);
      },
    );
  }

  Widget MySkillsView(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildSkills(context, snapshot.data.documents);
      },
    );
  }
}

Widget _buildSkills(BuildContext context, List<DocumentSnapshot> snapshots) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Wrap(
          spacing: 5.0,
          runSpacing: 5.0,
          direction: Axis.horizontal,
          children: Profile.fromSnapshot(snapshots[0]).skills
              .map((skill) => BubbleItem(skill.documentID, Colors.orange))
              .toList()),
    ),
  );
}

Widget _buildFields(BuildContext context, List<DocumentSnapshot> snapshots) {
  final profile = Profile.fromSnapshot(snapshots[0]);
  return GridView.count(
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
      GridTile(child: Text(profile.name)),
      GridTile(
          child: Text(
        'Email',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      GridTile(child: Text(profile.mail)),
      GridTile(
          child: Text(
        'City',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      GridTile(child: Text(profile.city)),
    ],
  );
}

class MyProjectOverview extends ProjectOverview {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Projects')
          .where("ismyproject", isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return buildListView(context, snapshot.data.documents);
      },
    );
  }
}

class Profile {
  final String name;
  final String mail;
  final String city;
  final List skills;

  Profile.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        name = map['name'],
        mail = map['mail'],
        city = map['city'],
        skills = map['skills'];

  Profile.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data);
}
