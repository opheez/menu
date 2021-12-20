import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {

  // makes this a singleton class
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential, callback) async {
    late final UserCredential? authCredential;
    late final String errorMsg;
    try{
      authCredential = await _auth.signInWithCredential(phoneAuthCredential);
      errorMsg = "";
    } on FirebaseAuthException catch (e){
      errorMsg = e.message as String;
      authCredential = null;
    }
    callback(authCredential, errorMsg);
  }

  // Future<void> phoneSignIn(
  //     {required String phoneNumber,
  //     required Function verifiedCallback,
  //     required Function verifyFailedCallback,
  //     required Function codeSentCallback}) async {
  //   await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       timeout: const Duration(seconds: 60),
  //       verificationCompleted: (authCredential) =>
  //           _onVerificationCompleted(authCredential, verifiedCallback),
  //       verificationFailed: (exception) =>
  //           _onVerificationFailed(exception, verifyFailedCallback),
  //       codeSent: (verificationId, forceResendingToken) =>
  //           _onCodeSent(verificationId, forceResendingToken, codeSentCallback),
  //       codeAutoRetrievalTimeout: _onCodeTimeout);
  // }
  //
  // _onVerificationCompleted(
  //     PhoneAuthCredential authCredential, Function callback) async {
  //   print("verification completed ${authCredential.smsCode}");
  //   User? user = _auth.currentUser;
  //   setState(() {
  //     this.otpCode.text = authCredential.smsCode!;
  //   });
  //   if (authCredential.smsCode != null) {
  //     try {
  //       UserCredential credential =
  //           await user!.linkWithCredential(authCredential);
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'provider-already-linked') {
  //         await _auth.signInWithCredential(authCredential);
  //       }
  //     }
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, Constants.homeNavigate, (route) => false);
  //   }
  // }
  //
  // _onVerificationFailed(FirebaseAuthException exception, Function callback) {
  //   if (exception.code == 'invalid-phone-number') {
  //     callback("The phone number entered is invalid!");
  //   }
  // }
  //
  // _onCodeSent(
  //     String verificationId, int? forceResendingToken, Function callback) {
  //   callback(verificationId);
  //   // this.verificationId = verificationId;
  //   print(forceResendingToken);
  //   print("code sent");
  // }
  //
  // _onCodeTimeout(String timeout) {
  //   return null;
  // }
  //
  // void showMessage(String errorMessage) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext builderContext) {
  //         return AlertDialog(
  //           title: Text("Error"),
  //           content: Text(errorMessage),
  //           actions: [
  //             TextButton(
  //               child: Text("Ok"),
  //               onPressed: () async {
  //                 Navigator.of(builderContext).pop();
  //               },
  //             )
  //           ],
  //         );
  //       }).then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }
}
