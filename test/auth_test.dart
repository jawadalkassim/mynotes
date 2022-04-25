import 'package:demoapp/services/auth/auth_exeptions.dart';
import 'package:demoapp/services/auth/auth_provider.dart';
import 'package:demoapp/services/auth/auth_user.dart';
import 'package:test/test.dart';

//Test Code
// Create Test Groups and Test Our App
void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedExpection>()),
      );
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
          () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'anypassword',
      );

      expect(badEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthExeption>()));

      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthExeption>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerfified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerfified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'email',
        password: 'password',
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedExpection implements Exception{}
class MockAuthProvider implements AuthProvider{
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
  if (!isInitialized) throw NotInitializedExpection();
  await Future.delayed(const Duration(seconds: 1));
  return logIn(email: email, password: password);
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async{
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password,
  }) {
   if (!isInitialized) throw NotInitializedExpection();
   if (email == 'foo@bar.com') throw UserNotFoundAuthExeption();
   if (password == 'foobar') throw WrongPasswordAuthExeption();
   const user = AuthUser(isEmailVerfified: false);
   _user= user;
   return Future.value(user);
  }

  @override
  Future<void> logOut() async{
    if (!isInitialized) throw NotInitializedExpection();
    if (_user == null) throw UserNotFoundAuthExeption();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async{
    if (!isInitialized) throw NotInitializedExpection();
    final user = _user;
    if (user == null) throw UserNotFoundAuthExeption();
    const newUser = AuthUser(isEmailVerfified: true);
    _user = newUser;
  }

}