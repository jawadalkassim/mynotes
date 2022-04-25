import 'package:demoapp/services/auth/auth_exeptions.dart';
import 'package:demoapp/services/auth/auth_services.dart';
import 'package:demoapp/utilities/show_error_dialog.dart';
import 'package:demoapp/views/register_view.dart';
import 'package:flutter/material.dart';
import '../constant/routes.dart';
import '../firebase_options.dart';

import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _loginViewState();
}

class _loginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose(); // TODO: implement dispose
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController(); // TODO: implement initState
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'Enter your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerfified ?? false) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthExeption{
                    await showErrorDialog(
                    context,
                    'User Not Found',
                  );

              } on WrongPasswordAuthExeption{
                
                await showErrorDialog(
                    context,
                    'Wrong Password, Try Agian',
                  );
              }on GenericAuthExeption{
                await showErrorDialog(
                  context,
                  'Authenication Error',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (route) => false,
                );
              },
              child: const Text('Not Registered? Login Here'))
        ],
      ),
    );
  }
}
