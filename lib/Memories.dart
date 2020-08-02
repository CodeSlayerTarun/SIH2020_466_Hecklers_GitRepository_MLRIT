import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String email;
  final String id;

  User({this.name, this.email, this.id});
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc.documentID,
      name: doc['name'],
    );
  }
}
