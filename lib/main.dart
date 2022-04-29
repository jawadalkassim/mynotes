// import 'dart:io';
// import 'dart:js';
import 'package:demoapp/services/auth/auth_services.dart';
import 'package:demoapp/views/login_view.dart';
import 'package:demoapp/views/notes_view.dart';
import 'package:demoapp/views/register_view.dart';
import 'package:demoapp/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'constant/routes.dart';
import 'dart:developer' as devtools show log;

void log() {}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null && user.isEmailVerfified) {
              devtools.log('Email is Verfied');
            } else {
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
