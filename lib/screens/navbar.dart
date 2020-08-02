// import 'package:flutter/material.dart';

// class NavBarScreen extends StatefulWidget {
//   @override
//   _NavBarScreenState createState() => _NavBarScreenState();
// }

// class _NavBarScreenState extends State<NavBarScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: BubbleBottomBar(
//           opacity: 0.2,
//           backgroundColor: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
//           currentIndex: currentIndex,
//           hasInk: true,
//           inkColor: Colors.green[200],
//           elevation: 8.0,
//           onTap: changePage,
//           items: <BubbleBottomBarItem>[
//             BubbleBottomBarItem(
//               backgroundColor: Colors.green,
//               icon: Icon(Icons.public, color: Colors.black),
//               activeIcon: Icon(Icons.public, color: Colors.green),
//               title: Text('Trips'),
//             ),
//             BubbleBottomBarItem(
//               backgroundColor: Colors.green,
//               icon: Icon(Icons.person, color: Colors.black),
//               activeIcon: Icon(Icons.person, color: Colors.green),
//               title: Text('Solo'),
//             ),
//             BubbleBottomBarItem(
//               backgroundColor: Colors.green,
//               icon: Icon(Icons.supervisor_account, color: Colors.black),
//               activeIcon: Icon(Icons.supervisor_account, color: Colors.green),
//               title: Text('Clan'),
//             ),
//             BubbleBottomBarItem(
//               backgroundColor: Colors.green,
//               icon: Icon(Icons.timeline, color: Colors.black),
//               activeIcon: Icon(Icons.timeline, color: Colors.green),
//               title: Text('Ranking'),
//             ),
//             BubbleBottomBarItem(
//               backgroundColor: Colors.green,
//               icon: Icon(Icons.account_circle, color: Colors.black),
//               activeIcon: Icon(Icons.account_circle, color: Colors.green),
//               title: Text('Account'),
//             ),
//           ],
//         ),
//         body:(currentIndex == 0) 
//         ? 
//         Icon(Icons.ac_unit) // Trip Screen

//         :  (currentIndex == 1) 
//         ? 
//         Icon(Icons.favorite) //  Solo Screen

//         : (currentIndex == 2)
//         ? 
//         Icon(Icons.access_alarm) // Clan Screen
//         : (currentIndex == 3)
//         ?
//         RankingPage() // Ranking Screen
//         :
//         ProfilePage(), // Profile Screen

//       );
//   }
// }