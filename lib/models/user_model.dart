import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String displayName;
  final String photoURL;

  User({this.uid, this.displayName, this.photoURL});
  factory User.fromSnap(DocumentSnapshot doc) {
    return User(
      uid: doc.data['uid'] ?? '',
      displayName: doc.data['displayName'] ?? '',
      photoURL: doc.data['photoURL'] ?? '',
    );
  }
}
