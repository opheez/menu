import 'package:firebase_auth/firebase_auth.dart';
import 'package:menu/models/user.dart' as model;

class AuthService {
  // makes this a singleton class
  AuthService._privateConstructor();

  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  signInWithPhoneAuthCredential(verificationId, smsCode, callback) async {
    final phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    late final UserCredential? authCredential;
    late final String errorMsg;
    try {
      authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      // TODO: create user if does not exist in db
      errorMsg = "";
    } on FirebaseAuthException catch (e) {
      errorMsg = e.message as String;
      authCredential = null;
    }
    callback(authCredential, errorMsg);
  }

  Future<void> phoneSignIn(
      {required String phoneNumber,
      required Function verifiedCallback,
      required Function verifyFailedCallback,
      required Function codeSentCallback}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (authCredential) =>
            _onVerificationCompleted(authCredential, verifiedCallback),
        verificationFailed: (exception) =>
            _onVerificationFailed(exception, verifyFailedCallback),
        codeSent: (verificationId, forceResendingToken) =>
            _onCodeSent(verificationId, forceResendingToken, codeSentCallback),
        codeAutoRetrievalTimeout: _onCodeTimeout);
  }

  _onVerificationCompleted(
      PhoneAuthCredential authCredential, Function callback) async {
    callback(authCredential);
  }

  _onVerificationFailed(FirebaseAuthException exception, Function callback) {
    callback(exception.message);
  }

  _onCodeSent(
      String verificationId, int? forceResendingToken, Function callback) {
    callback(verificationId);
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void signOut() async {
    await _auth.signOut();
  }

  model.User? getCurrentUser() {
    User? user = _auth.currentUser;
    // TODO: fetch user from database
    if (user != null) {
      return model.User(
          uid: user.uid,
          phoneNumber: user.phoneNumber!,
          name: user.displayName ?? "",
          classYear: 0,
          communities: [],
          eventsAttending: [],
          eventsHosting: []);
    }
    return null;
  }

  Stream<model.User?> getUserStream() {
    return _auth.authStateChanges().map((authUser) => authUser == null
        ? null
        : model.User(
            uid: authUser.uid,
            phoneNumber: authUser.phoneNumber!,
            name: authUser.displayName ?? "",
            classYear: 0,
            communities: [],
            eventsAttending: [],
            eventsHosting: []));
  }
}
