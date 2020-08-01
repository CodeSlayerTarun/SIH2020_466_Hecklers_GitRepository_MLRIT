import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memories/models/user_model.dart';
import 'dart:async';

class AuthService {
  // Dependencies
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  final StreamController<Map<String, dynamic>> controller =
      StreamController<Map<String, dynamic>>();
  // Shared State for Widgets
  Stream<FirebaseUser> user; // firebase user
  Stream<Map<String, dynamic>> profile; // custom user data in Firestore

  Stream<User> streamUser({String uid}) {
    return db
        .collection('users')
        .document(uid)
        .snapshots()
        .map((snap) => User.fromSnap(snap));
  }

  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

    updateUserData(user);

    return user;
  }

  void updateUserData(FirebaseUser user) async {
    var userDetails;
    DocumentReference ref = db.collection('users').document(user.uid);
    await ref.get().then((value) {
      userDetails = value.data;
    });
    if (userDetails != null) {
      var totalDistance;
      if (userDetails['totalDistance'] == null) {
        totalDistance = 0.0;
      } else {
        totalDistance = userDetails['totalDistance'];
      }
      return ref.setData({
        'uid': userDetails['uid'],
        'email': userDetails['email'],
        'photoURL': userDetails['photoURL'],
        'displayName': userDetails['displayName'],
        'totalDistance': totalDistance,
      }, merge: true);
    } else {
      print('Setting Default data');
      return ref.setData({
        'uid': user.uid,
        'email': user.email,
        'photoURL': user.photoUrl,
        'displayName': user.displayName,
        'totalDistance': 0.0
      }, merge: true);
    }
  }

  Stream returnEmptyUser() {
    Stream stream = controller.stream;
    controller.add({});
    return stream;
  }

  void signOut() {
    _auth.signOut();
  }
}

final AuthService authService = AuthService();
