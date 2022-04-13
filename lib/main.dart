// import 'dart:io';
// import 'dart:js';

import 'package:demoapp/views/login_view.dart';
import 'package:demoapp/views/register_view.dart';
import 'package:demoapp/views/verify_email_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null && user.emailVerified){
             print('Email is Verfied');
            }
            else{
            return VerifyEmailView();
            }

            // if (user?.emailVerified ?? false) {
            //   print('Email Verified');
            // } else {
            //   return const VerifyEmailView();
            // }
            return LoginView();
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
