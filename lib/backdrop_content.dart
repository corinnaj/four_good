import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FilterItem extends StatefulWidget {
	final String text;

	FilterItem(this.text);

	@override
	_FilterItemState createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
	bool isSelected;

	@override
	void initState() {
		isSelected = false;
		super.initState();
	}

	@override
	Widget build(BuildContext context) {
		return InkWell(
			onTap: () => setState(() => isSelected = !isSelected),
			child: Container(
				decoration: BoxDecoration(
					color: isSelected ? Colors.blue : Colors.white, borderRadius: BorderRadius.circular(15.0)),
				child: Padding(
					padding: const EdgeInsets.all(8.0),
					child: Text(widget.text,
						//textAlign: TextAlign.center,
						style: Theme.of(context)
							.textTheme
							.body1
							.copyWith(color: isSelected ? Colors.white : Colors.indigo)),
				),
			),
		);
	}
}

class BackdropContent extends StatelessWidget {

	Widget _buildSkillsView(BuildContext context, List<DocumentSnapshot> documents) {
		return Center(
		  child: Wrap(
		  	spacing: 8.0,
		  	runSpacing: 8.0,
		  	direction: Axis.horizontal,
		  	children: documents.map((document) => FilterItem(document.documentID)).toList()
		  ),
		);
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			color: Theme.of(context).primaryColor,
			child: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						TextField(
							decoration: InputDecoration(
								fillColor: Colors.white,
								filled: true,
								hintText: 'Filter by key words...',
								prefixIcon: Icon(Icons.search),
							),
						),
						SizedBox(
							height: 16.0,
						),
						Text(
							'Location',
							style: Theme.of(context)
								.textTheme
								.subtitle
								.copyWith(color: Colors.white),
						),
						SizedBox(
							height: 8.0,
						),
						TextField(
							decoration: InputDecoration(
								fillColor: Colors.white,
								filled: true,
								hintText: 'Stadt',
								prefixIcon: Icon(Icons.location_city),
								border: InputBorder.none
							),
						),
						SizedBox(
							height: 16.0,
						),
						Text(
							'Skills',
							style: Theme.of(context)
								.textTheme
								.subtitle
								.copyWith(color: Colors.white),
						),
						SizedBox(
							height: 8.0,
						),
						StreamBuilder(
							stream: Firestore.instance.collection('Skills').snapshots(),
							builder: (BuildContext context, AsyncSnapshot snapshot) {
								if (!snapshot.hasData) return LinearProgressIndicator();

								return _buildSkillsView(context, snapshot.data.documents);
							},
						)
					],
				),
			),
		);
	}
}
