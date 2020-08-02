import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/utils/constants.dart';

class ClanChat extends StatefulWidget {
  final Map<String, dynamic> clanData;
  final String userID;
  final String user;
  ClanChat({this.clanData, this.userID, this.user});
  @override
  _ClanChatState createState() => _ClanChatState(
      clanInfo: clanData, currentUserName: user, currentUserID: userID);
}

class _ClanChatState extends State<ClanChat> {
  Firestore _db = Firestore.instance;
  Map<String, dynamic> clanInfo;
  String currentUserName;
  String currentUserID;
  String message;

  final _messageController = TextEditingController();
  _ClanChatState({this.clanInfo, this.currentUserID, this.currentUserName});
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.grey),
                ),
              ),
              child: Center(
                child: Hero(
                  tag: 'ClanName',
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        clanInfo['clanName'],
                        style: kCardTitle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _db
                    .collection('clans')
                    .document(clanInfo['clanID'])
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var messages = snapshot.data.documents;
                    if (messages.length > 0) {
                      return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            var messagesData = messages[index].data;
                            bool isME =
                                (messagesData['senderID'] == currentUserID);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 5.0),
                              child: Column(
                                crossAxisAlignment: (isME)
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8.0, right: 8.0),
                                    child: Text(
                                      messagesData['senderName'],
                                      style: TextStyle(fontSize: 10.0),
                                    ),
                                  ),
                                  Card(
                                      color: isME
                                          ? Colors.pink[50]
                                          : Colors.amber[50],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          messagesData['message'],
                                          style: TextStyle(fontSize: 15.0),
                                        ),
                                      )),
                                ],
                              ),
                            );
                          });
                    } else {
                      return Text('No messages');
                    }
                  } else {
                    return Text('No messages');
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2.0, color: Colors.grey),
                ),
              ),
              child: Center(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, bottom: 10.0),
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Enter Message',
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {
                            message = value;
                          },
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (message.length > 0) {
                            _messageController.clear();
                            var docRef = _db
                                .collection('clans')
                                .document(clanInfo['clanID'])
                                .collection('messages')
                                .document();
                            var messageType = 'string';
                            docRef.setData({
                              'messageID': docRef.documentID,
                              'message': message,
                              'senderName': currentUserName,
                              'senderID': currentUserID,
                              'timestamp': DateTime.now(),
                              'messageType': messageType,
                            });
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
