/*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chet/Widget/sign_up_button_widget.dart';

import 'package:my_chet/provider/google_sign_in.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context)=>GoogleSignInProvider(),
        child:Center(child: GoogleSignupButtonWidget()) ,
      )

      */
/*StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshort) {
          if (snapshort.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshort.hasData) {
            return LoggedInWidget();
          } else if (snapshort.hasError) {
            return Center(
              child: Text('Someting Went Wrong!'),
            );
          } else {
            return HomePage();
          }
        },
      ),*//*

    );
  }
}

*/


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chet/Widget/backgroung.dart';
import 'package:my_chet/Widget/logged_In_Widget.dart';
import 'package:my_chet/Widget/sign_up.dart';
import 'package:my_chet/provider/google_sign_in.dart';

import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context);

          if (provider.isSigningIn) {
            return buildLoading();
          } else if (snapshot.hasData) {
            return LoggedInWidget();
          } else {
            return SignUpWidget();
          }
        },
      ),
    ),
  );

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      CustomPaint(painter: BackgroundPainter()),
      Center(child: CircularProgressIndicator()),
    ],
  );
}
