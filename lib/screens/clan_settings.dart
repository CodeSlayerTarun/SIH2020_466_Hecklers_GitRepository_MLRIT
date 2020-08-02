import 'package:flutter/material.dart';

class ClanInfo extends StatefulWidget {
  final String currentUserID;
  final String currentUserName;
  final Map clanInfo;
  ClanInfo({this.currentUserID, this.currentUserName, this.clanInfo});
  @override
  _ClanInfoState createState() => _ClanInfoState(
      userID: currentUserID, userName: currentUserName, clanDetails: clanInfo);
}

class _ClanInfoState extends State<ClanInfo> {
  String userID;
  String userName;
  Map clanDetails;

  _ClanInfoState({this.userID, this.clanDetails, this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ClanInfo'),
      ),
    );
  }
}
