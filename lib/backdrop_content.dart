import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:four_good/date_time_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      onTap: () => setState(() {
            isSelected = !isSelected;
            //Firestore.instance
            //    .collection('Projects')
            //    .getDocuments()
            //    .then((snapshot) {
            //  snapshot.documents.forEach((doc) {
            //    if (doc.data['skills'] != null &&
            //        doc.data['skills'].contains(widget.text))
            //      doc.reference.updateData({'visibility': true});
            //    else
            //      doc.reference.updateData({'visibility': false});
            //  });
            //});
          }),
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
  //final StreamSink optionsSink;

  //BackdropContent(this.optionsSink);
  BackdropContent();

  @override
  _BackdropContentState createState() => _BackdropContentState();
}

class _BackdropContentState extends State<BackdropContent> {
  int radioValue;

  double _sliderValue = 300.0;

  @override
  void initState() {
    super.initState();
    radioValue = 0;
  }

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
    if (value == 0) {
      Firestore.instance.collection('Projects').getDocuments().then((snapshot) {
        snapshot.documents.forEach((doc) {
          if (doc.data['regularly'] == true)
            doc.reference.updateData({'commitVisibility': true});
          else
            doc.reference.updateData({'commitVisibility': false});
        });
      });
    }
    if (value == 1) {
      Firestore.instance.collection('Projects').getDocuments().then((snapshot) {
        snapshot.documents.forEach((doc) {
          if (doc.data['regularly'] == false)
            doc.reference.updateData({'commitVisibility': true});
          else
            doc.reference.updateData({'commitVisibility': false});
        });
      });
    }
    if (value == 2) {
      Firestore.instance.collection('Projects').getDocuments().then((snapshot) {
        snapshot.documents.forEach((doc) {
          doc.reference.updateData({'commitVisibility': true});
        });
      });
    }
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
              Text(
                'I want to be active regularly',
                style: style,
              )
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

  void _setKeyword(keyword) {
    Firestore.instance.collection('Projects').getDocuments().then((snapshot) {
      snapshot.documents.forEach((doc) {
        if (doc.data['title'].contains(keyword))
          doc.reference.updateData({'visibility': true});
        else
          doc.reference.updateData({'visibility': false});
      });
    });
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
              FlatButton.icon(
                padding: EdgeInsets.all(12.0),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                label: Text("Remove all filters"),
                icon: const Icon(FontAwesomeIcons.minusCircle, size: 18.0),
                onPressed: () {
                  setState(() {
                    radioValue = 2;
                    _sliderValue = 300.0;
                  });
                  Firestore.instance.collection('Projects').getDocuments().then((snapshot) {
                    snapshot.documents.forEach((doc) {
                      doc.reference.updateData({'commitVisibility': true});
                      doc.reference.updateData({'visibility': true});
                      doc.reference.updateData({'distanceVisibility': true});
                    });
                  });
                },
                splashColor: Theme.of(context).accentColor
              ),
              TextField(
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: 'Filter by key words...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none),
                onSubmitted: (text) => _setKeyword(text),
              ),
              SizedBox(
                height: 16.0,
              ),
/*                TextField(
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Stadt',
                      prefixIcon: Icon(Icons.location_city),
                      border: InputBorder.none),
                ),*/

              _buildItem(
                  (_sliderValue < 300.0)
                      ? 'Location not more then ' +
                          _sliderValue.toInt().toString() +
                          'km away:'
                      : 'No location restrictions!',
                  Slider(
                      min: 0.0,
                      max: 300.0,
                      value: _sliderValue,
                      activeColor: Colors.white,
                      inactiveColor: Colors.black,
                      onChanged: (newValue) {
                        setState(() {
                          _sliderValue = newValue;
                        });
                      },
                      onChangeEnd: (newValue) {
                        LatLng currentPosition = LatLng(52.394155, 13.132243);
                        Firestore.instance
                            .collection('Projects')
                            .getDocuments()
                            .then((snapshot) {
                          snapshot.documents.forEach((doc) {
                            if (_sliderValue == 300.0) {
                              doc.reference
                                  .updateData({'distanceVisibility': true});
                            } else if (doc.data['place'] == null)
                              doc.reference
                                  .updateData({'distanceVisibility': false});
                            else {
                              Distance distance = new Distance();
                              double kmDistance = distance.as(
                                  LengthUnit.Kilometer,
                                  currentPosition,
                                  new LatLng(doc['place'].latitude,
                                      doc['place'].longitude));
                              if (kmDistance >= _sliderValue) {
                                doc.reference
                                    .updateData({'distanceVisibility': false});
                              } else {
                                doc.reference
                                    .updateData({'distanceVisibility': true});
                              }
                            }
                          });
                        });
                      })),
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
