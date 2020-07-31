import 'dart:async';

//Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Shared prefrences & Flutter Toast
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  Future<bool> isSignedIn() async {
    isLoading = true;
    isLoggedIn = await _googleSignIn.isSignedIn();
    isLoading = false;
    if (isLoggedIn) {
      return true;
    } else {
      return false;
    }
  }

  // ignore: unused_element
  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(credential)).user;
    print("signed in " + firebaseUser.displayName);

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('uid', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'uid': firebaseUser.uid,
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
      }
      isLoading = false;
    } else {
      isLoading = false;
    }
    return firebaseUser;
  }
}
