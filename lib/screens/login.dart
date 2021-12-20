import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:menu/services/auth.dart';

import 'home.dart';

enum MobileVerificationState { MOBILE_FORM, OTP_FORM }

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MobileVerificationState currentState = MobileVerificationState.MOBILE_FORM;
  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService auth = AuthService.instance;

  late String verificationId;

  bool loading = false;

  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: mobileController,
          decoration: InputDecoration(hintText: "Phone Number"),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              _auth.verifyPhoneNumber(
                  phoneNumber: mobileController.text,
                  timeout: const Duration(seconds: 60),
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (exception) async {
                    setState(() {
                      loading = false;
                    });
                    _scaffoldKey.currentState?.showSnackBar(
                        SnackBar(content: Text(exception.message as String)));
                  },
                  codeSent: (verificationId, resendingToken) async {
                    setState(() {
                      currentState = MobileVerificationState.OTP_FORM;
                      this.verificationId = verificationId;
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (x) {});
            },
            child: Text("Verify")),
        Spacer()
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(hintText: "OTP"),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
            onPressed: () async {
              final phoneAuthCredential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: otpController.text);

              auth.signInWithPhoneAuthCredential(phoneAuthCredential,
                  (userCredential, errorMsg) {
                print(userCredential);
                setState(() {
                  loading = false;
                });

                if (userCredential != null && userCredential.user != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyHomePage(title: "logged in")));
                } else {
                  _scaffoldKey.currentState?.showSnackBar(
                      SnackBar(content: Text(errorMsg)));
                }
              });
            },
            child: Text("Verify")),
        Spacer()
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.MOBILE_FORM
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
        ));
  }
}
