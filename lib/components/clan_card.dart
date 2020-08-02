import 'package:flutter/material.dart';

class ClanCard extends StatefulWidget {
  final Map<String, dynamic> clanData;
  ClanCard({this.clanData});

  @override
  _ClanCardState createState() => _ClanCardState(clanData: clanData);
}

class _ClanCardState extends State<ClanCard> {
  Map<String, dynamic> clanData;
  _ClanCardState({this.clanData});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Card(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Text(clanData['clanName'])),
      ),
    );
  }
}
