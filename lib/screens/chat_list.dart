import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/screens/clan_chat.dart';

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
  var textController = TextEditingController();

  _ChatListState({this.id, this.userName});

  void createClan() {
    var docRef = _db.collection('clans').document();
    docRef.setData({
      'clanID': docRef.documentID,
      'clanName': _newClanName,
      'clanAdmin': {'adminID': id, 'adminName': userName},
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300.0,
                    child: TextField(
                      controller: textController,
                      autofocus: false,
                      style: TextStyle(fontSize: 22.0, color: Colors.black87),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'New Clan Name',
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 8.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(25.7),
                          )),
                      onChanged: (value) {
                        _newClanName = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: IconButton(
                      iconSize: 40.0,
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        if (_newClanName.length > 0) {
                          createClan();
                          textController.clear();
                        }
                      },
                    ),
                  )
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
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  height: 80.0,
                                  child: Card(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _clanData['clanName'],
                                                  style:
                                                      TextStyle(fontSize: 25.0),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20.0),
                                                child: Text(
                                                  _clanData['clanID'],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
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
                                                                clanData:
                                                                    _clanData,
                                                                userID: id,
                                                                user:
                                                                    userName)));
                                              })
                                        ],
                                      ),
                                    ),
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
