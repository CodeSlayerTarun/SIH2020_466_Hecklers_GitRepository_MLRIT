import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Rankings extends StatefulWidget {
  static String route = 'Rankings';
  @override
  _RankingsState createState() => _RankingsState();
}

class _RankingsState extends State<Rankings> {
  Firestore _db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _db
                      .collection('users')
                      .orderBy('totalDistance', descending: true)
                      .limit(3)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var rankers = snapshot.data.documents;
                      if (rankers.length > 0) {
                        List<Widget> rankHolders = [];
                        double changingFontSize = 25;
                        int rankBadge = 1;
                        for (var ranker in rankers) {
                          rankHolders.add(Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage(
                                          'assets/images/rank$rankBadge.png'),
                                      height: 45.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Text(
                                            ranker['displayName'],
                                            style: TextStyle(
                                                fontSize: changingFontSize),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            ranker['uid'],
                                            style: TextStyle(fontSize: 10.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        '${ranker['totalDistance'].toString()} kms',
                                        style: TextStyle(
                                            fontSize: (changingFontSize - 2.0),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ));
                          changingFontSize -= 2.0;
                          rankBadge += 1;
                        }
                        return Column(
                          children: rankHolders,
                        );
                      } else {
                        return Text('No Ranks Yet');
                      }
                    } else {
                      return Text('No Ranks Yet');
                    }
                  }),
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('assets/images/congo.gif'),
              height: 200.0,
            ),
          )
        ],
      ),
    );
  }
}
