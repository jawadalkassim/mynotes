import 'package:demoapp/firebase_options.dart';
import 'package:demoapp/services/auth/auth_exeptions.dart';
import 'package:demoapp/services/auth/auth_user.dart';
import 'package:demoapp/services/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthExeption;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthExeption();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthExeption();
      } else if (e.code == 'invaild-email') {
        throw InvalidEmailAuthExeption();
      } else {
        throw GenericAuthExeption();
      }
    } catch (_) {
      throw GenericAuthExeption();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthExeption;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthExeption();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthExeption();
      } else {
        throw GenericAuthExeption();
      }
    } catch (e) {
      throw GenericAuthExeption();
    }
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthExeption();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
