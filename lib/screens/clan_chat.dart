import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClanChat extends StatefulWidget {
  final Map<String, dynamic> clanData;
  ClanChat({this.clanData});
  @override
  _ClanChatState createState() => _ClanChatState(clanInfo: clanData);
}

class _ClanChatState extends State<ClanChat> {
  Firestore _db = Firestore.instance;
  Map<String, dynamic> clanInfo;
  _ClanChatState({this.clanInfo});
  @override
  void initState() {
    super.initState();
    print('InsideClanChat');
    print(clanInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text(clanInfo.toString()),
            StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection('clans')
                  .document(clanInfo['clanID'])
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot) {
                // TODO: Write logic for displaying clan messages.
                // Refer ClanList Module for retieving data from StreamBuilders or watch tutorials
              },
            ),
          ],
        ),
      ),
    );
  }
}
