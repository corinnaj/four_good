import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_good/date_time_picker.dart';

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
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.text,
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: isSelected ? Colors.white : Colors.indigo)),
        ),
      ),
    );
  }
}

class BackdropContent extends StatefulWidget {
  @override
  _BackdropContentState createState() => _BackdropContentState();
}

class _BackdropContentState extends State<BackdropContent> {
  int radioValue;

  @override
  void initState() {
    super.initState();
    radioValue = 0;
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  Widget _buildSkillsView(
      BuildContext context, List<DocumentSnapshot> documents) {
    return Center(
      child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          direction: Axis.horizontal,
          children: documents
              .map((document) => FilterItem(document.documentID))
              .toList()),
    );
  }

  Widget _buildRadioButtons() {
  	TextStyle style = TextStyle(color: Colors.white);
    return Theme(
			data: ThemeData(brightness: Brightness.dark),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio<int>(
                value: 0,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),
						Text('I want to be active regularly', style: style,)
            ],
          ),
          Row(
            children: <Widget>[
              Radio<int>(
                value: 1,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),
						Text('I can only participate once', style: style),
            ],
          ),
          Row(
            children: <Widget>[
              Radio<int>(
                value: 2,
                groupValue: radioValue,
                onChanged: handleRadioValueChanged,
              ),
						Text('I want to see all opportunities', style: style)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .subtitle
              .copyWith(color: Colors.white),
        ),
        SizedBox(
          height: 8.0,
        ),
        child,
        SizedBox(
          height: 16.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Filter by key words...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none),
              ),
              SizedBox(
                height: 16.0,
              ),
              _buildItem(
                'Location',
                TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Stadt',
                      prefixIcon: Icon(Icons.location_city),
                      border: InputBorder.none),
                ),
              ),
              _buildItem(
                'Date',
                DateAndTimePickerDemo(),
              ),
              _buildItem(
                'Commitment',
                _buildRadioButtons(),
              ),
              _buildItem(
                'Skills',
                StreamBuilder(
                  stream: Firestore.instance.collection('Skills').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return LinearProgressIndicator();

                    return _buildSkillsView(context, snapshot.data.documents);
                  },
                ),
              ),
							SizedBox(height: 30.0)
            ],
          ),
        ),
      ),
    );
  }
}
