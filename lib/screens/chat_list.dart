import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/screens/clan_chat.dart';
import 'package:memories/utils/constants.dart';

class ChatList extends StatefulWidget {
  static String route = 'ChatList';
  final String userID;
  final String user;
  ChatList({this.userID, this.user});
  @override
  _ChatListState createState() => _ChatListState(id: userID, userName: user);
}

class _ChatListState extends State<ChatList> {
  String id;
  String userName;
  Firestore _db = Firestore.instance;
  String _newClanName;

  _ChatListState({this.id, this.userName});

  void createClan() {
    var docRef = _db.collection('clans').document();
    docRef.setData({
      'clanID': docRef.documentID,
      'clanName': _newClanName,
      'clanAdmin': id,
      'members': [
        {
          'uid': id,
          'userName': userName,
        }
      ],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 100.0,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Clan Name',
                      ),
                      onChanged: (value) {
                        _newClanName = value;
                      },
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      createClan();
                      _newClanName = '';
                    },
                    child: Text('Create New Clan'),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: StreamBuilder<QuerySnapshot>(
                  stream: _db.collection('clans').where('members',
                      arrayContains: {
                        'uid': id,
                        'userName': userName
                      }).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var clans = snapshot.data.documents;
                      if (clans.length > 0) {
                        return ListView.builder(
                            itemCount: clans.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              var _clanData = clans[index].data;
                              return Container(
                                height: 60.0,
                                child: Card(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            _clanData['clanName'],
                                            style: kCardTitle,
                                          ),
                                          Text(
                                            _clanData['clanID'],
                                            style: kCardSubtitle,
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          icon: Icon(Icons.arrow_forward),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClanChat(
                                                          clanData: _clanData,
                                                        )));
                                          })
                                    ],
                                  ),
                                ),
                              );
                            });
                      } else {
                        return Text('No Clans Yet');
                      }
                    } else {
                      return Text('No Clans Yet');
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
