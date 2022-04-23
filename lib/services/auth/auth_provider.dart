import 'package:demoapp/services/auth/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
//   async{
// try{
// await FirebaseAuth.instance.createUserWithEmailAndPassword(
// email: email,
// password: password,);
// }on FirebaseAuthException catch(e){

// }catch(_){

// }
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
