import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final userDetails;
  ProfilePage({this.userDetails});
  @override
  _ProfilePageState createState() => _ProfilePageState(userData: userDetails);
}

class _ProfilePageState extends State<ProfilePage> {
  var userData;
  _ProfilePageState({this.userData}) {
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.transparent,
    //       elevation: 0.0,
    //     ),
    //     body: ListView(
    //       children: <Widget>[
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Hero(
    //               tag: 'assets/images/avatar.png',
    //               child: Container(
    //                 height: 125.0,
    //                 width: 125.0,
    //                 decoration: BoxDecoration(
    //                   borderRadius: BorderRadius.circular(62.5),
    //                   image: DecorationImage(
    //                     fit: BoxFit.cover,
    //                     image: NetworkImage(photoUrl),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: 25.0),
    //             Text(
    //               displayName,
    //               style: TextStyle(
    //                   fontFamily: 'Roboto',
    //                   fontSize: 20.0,
    //                   fontWeight: FontWeight.bold),
    //             ),
    //             SizedBox(height: 4.0),
    //             Text(
    //               email,
    //               style: TextStyle(fontFamily: 'Roboto', color: Colors.grey),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.all(30.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: <Widget>[
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: <Widget>[
    //                       Text(
    //                         '24K',
    //                         style: TextStyle(
    //                             fontFamily: 'Roboto',
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       SizedBox(height: 5.0),
    //                       Text(
    //                         'FOLLOWERS',
    //                         style: TextStyle(
    //                             fontFamily: 'Roboto', color: Colors.grey),
    //                       )
    //                     ],
    //                   ),
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: <Widget>[
    //                       Text(
    //                         '31',
    //                         style: TextStyle(
    //                             fontFamily: 'Roboto',
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       SizedBox(height: 5.0),
    //                       Text(
    //                         'TRIPS',
    //                         style: TextStyle(
    //                             fontFamily: 'Roboto', color: Colors.grey),
    //                       )
    //                     ],
    //                   ),
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: <Widget>[
    //                       Text(
    //                         '21',
    //                         style: TextStyle(
    //                             fontFamily: 'Roboto',
    //                             fontWeight: FontWeight.bold),
    //                       ),
    //                       SizedBox(height: 5.0),
    //                       Text(
    //                         'Planned',
    //                         style: TextStyle(
    //                             fontFamily: 'Roboto', color: Colors.grey),
    //                       )
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.only(left: 15.0),
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   IconButton(
    //                     icon: Icon(Icons.table_chart),
    //                     onPressed: () {},
    //                   ),
    //                   IconButton(
    //                     icon: Icon(Icons.menu),
    //                     onPressed: () {},
    //                   )
    //                 ],
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ),
    //   ),
    // );
    return Text("Profile page");
  }
}
