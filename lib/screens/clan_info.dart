import 'package:flutter/material.dart';
import 'package:memories/utils/constants.dart';

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
  String addUserID;
  var textController = TextEditingController();
  _ClanInfoState({this.userID, this.clanDetails, this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Image(
                        image: AssetImage('assets/images/message.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(clanDetails['clanName']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('Clan ID ${clanDetails['clanID']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                        'Clan Admin ${clanDetails['clanAdmin']['adminName']}'),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: textController,
                              decoration: InputDecoration(
                                hintText: 'User ID',
                                fillColor: Colors.white,
                              ),
                              onChanged: (value) {
                                addUserID = value;
                              },
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                print('Add user');
                              }),
                        ],
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Members',
                                style: kCardTitle,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: clanDetails['members'].length,
                                  itemBuilder: (BuildContext cntxt, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.grey[200],
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8.0),
                                          child: Text(clanDetails['members']
                                              [index]['userName']),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
