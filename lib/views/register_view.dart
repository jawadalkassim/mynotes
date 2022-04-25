// import 'package:demoapp/firebase_options.dart';
import 'package:demoapp/services/auth/auth_exeptions.dart';
import 'package:demoapp/services/auth/auth_services.dart';
import 'package:demoapp/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../constant/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'input your email'),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(hintText: 'input your password'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                final user = AuthService.firebase().currentUser;
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on EmailAlreadyInUseAuthExeption {
                await showErrorDialog(
                  context,
                  'Email is Already in use',
                );
              } on WeakPasswordAuthExeption {
                await showErrorDialog(
                  context,
                  'Weak Password',
                );
              } on InvalidEmailAuthExeption {
                await showErrorDialog(
                  context,
                  'Invalid Email',
                );
              }
              on GenericAuthExeption {
                await showErrorDialog(
                  context,
                  'Authenication Error',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already Registerd? Sign in Here'))
        ],
      ),
    );
  }
}
