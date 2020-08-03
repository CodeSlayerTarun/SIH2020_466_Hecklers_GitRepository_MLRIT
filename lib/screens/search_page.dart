import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:memories/screens/search_service.dart';

import 'mycustom_form.dart';

class SearchPage extends StatefulWidget {
  static String route = 'SearchPage';
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
        value.substring(0, 1).substring(0,1) + value.substring(1);

    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['places'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Itineary search',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val) {
                initiateSearch(val);
              },
              decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.only(left: 25.0),
                  hintText: 'Search by place....',
                  suffixIcon: Icon(
                    Icons.search,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 16.0,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(4.0))),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
          ListView(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Button pressed');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCustomForm()),
          );
        },
        elevation: 2.0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}

Widget buildResultCard(element) {
  return ListTile(
    title: Text(
      element['places'],
      style: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
    ),
    subtitle: Text(
      element['body'],
      style: TextStyle(
        color: Colors.black87,
        fontSize: 15.0,
      ),
    ),
  );
}
