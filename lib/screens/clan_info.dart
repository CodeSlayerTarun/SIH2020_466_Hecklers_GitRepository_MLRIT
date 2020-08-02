import 'package:cloud_firestore/cloud_firestore.dart';
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
  Firestore _db = Firestore.instance;
  var textController = TextEditingController();
  bool isAdmin = false;
  _ClanInfoState({this.userID, this.clanDetails, this.userName}) {
    isAdmin = (clanDetails['clanAdmin']['adminID'] == userID);
    print('isADmin $isAdmin');
  }

  Future<bool> addNewUser({List members}) async {
    String newUserName;
    bool success = true;
    try {
      await _db.collection('users').document(addUserID).get().then((value) {
        print(value.data);
        if (value.data.length > 0) {
          newUserName = value.data['displayName'];
          var dataToBeAdded = {
            'uid': addUserID,
            'userName': newUserName,
          };
          print(members.contains(dataToBeAdded));
          if (!members.contains(dataToBeAdded)) {
            _db.collection('clans').document(clanDetails['clanID']).updateData({
              'members': FieldValue.arrayUnion([dataToBeAdded])
            });
          }
        } else {
          success = false;
        }
      });
    } catch (e) {
      success = false;
    }
    return success;
  }

  void removeUser(userInfo) async {
    try {
      await _db.collection('clans').document(clanDetails['clanID']).updateData({
        'members': FieldValue.arrayRemove([userInfo])
      });
    } catch (e) {
      print(e);
      print('Unsuccessful Deletion');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: _db
              .collection('clans')
              .document(clanDetails['clanID'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var snapshotData = snapshot.data;
              if (snapshotData.data.length > 0) {
                var clanLiveInfo = snapshotData.data;
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Center(
                                child: Image(
                                  image:
                                      AssetImage('assets/images/message.png'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(clanLiveInfo['clanName']),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Clan ID ${clanLiveInfo['clanID']}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                  'Clan Admin ${clanLiveInfo['clanAdmin']['adminName']}'),
                            ),
                            if (isAdmin) ...[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        onPressed: () async {
                                          if (addUserID.length > 0) {
                                            var result = await addNewUser(
                                                members:
                                                    clanLiveInfo['members']);
                                            if (result) {
                                              print('Added');
                                            } else {
                                              print('User not found');
                                            }
                                          } else {
                                            print('User not found');
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ],
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
                                            itemCount:
                                                clanLiveInfo['members'].length,
                                            itemBuilder: (BuildContext cntxt,
                                                int index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  color: Colors.grey[200],
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(clanLiveInfo[
                                                                    'members']
                                                                [index]
                                                            ['userName']),
                                                        if (isAdmin) ...[
                                                          IconButton(
                                                              icon: Icon(
                                                                  Icons.delete),
                                                              onPressed: () {
                                                                var userData = {
                                                                  'uid': clanLiveInfo[
                                                                          'members']
                                                                      [
                                                                      index]['uid'],
                                                                  'userName': clanLiveInfo[
                                                                              'members']
                                                                          [
                                                                          index]
                                                                      [
                                                                      'userName']
                                                                };
                                                                removeUser(
                                                                    userData);
                                                              }),
                                                        ],
                                                      ],
                                                    ),
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
                );
              } else {
                print('Clan not found');
                return Text('Clan not found');
              }
            } else {
              print('Clan not found');
              return Text('Clan not found');
            }
          }),
    );
  }
}
