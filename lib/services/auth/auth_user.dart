import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerfified;
  const AuthUser({required this.isEmailVerfified});

  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerfified: user.emailVerified);
}
