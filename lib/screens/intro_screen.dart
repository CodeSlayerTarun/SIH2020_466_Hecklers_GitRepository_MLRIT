import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:memories/services/auth.dart';

class IntroScreen extends StatelessWidget {
  static String route = 'IntroScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.asset('assets/images/illustration.png'),
            ),
            Expanded(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Memories',
                      style: TextStyle(fontSize: 70.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        authService.googleSignIn();
                      },
                      elevation: 3.0,
                      fillColor: Colors.white,
                      child: FaIcon(
                        FontAwesomeIcons.google,
                        size: 30.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
