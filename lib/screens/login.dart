import 'package:flutter/material.dart';
import 'package:menu/services/auth.dart';

import 'home.dart';

enum MobileVerificationState { MOBILE_FORM, OTP_FORM }

class Login extends StatefulWidget {
  final Function setUser;
  
  const Login({Key? key, required this.setUser}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  MobileVerificationState currentState = MobileVerificationState.MOBILE_FORM;
  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  final AuthService auth = AuthService.instance;

  late String verificationId;

  bool loading = false;

  getMobileFormWidget(context) {
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: mobileController,
          decoration: const InputDecoration(hintText: "Phone Number"),
        ),
        const SizedBox(
          height: 16,
        ),
        FlatButton(
            onPressed: () async {
              setState(() {
                loading = true;
              });
              auth.phoneSignIn(
                  phoneNumber: mobileController.text,
                  verifiedCallback: (phoneAuthCredential) async {
                    setState(() {
                      loading = false;
                    });
                  },
                  verifyFailedCallback: (errorMsg) async {
                    setState(() {
                      loading = false;
                    });
                    _scaffoldKey.currentState?.showSnackBar(
                        SnackBar(content: Text(errorMsg)));
                  },
                  codeSentCallback: (verificationId) async {
                    setState(() {
                      currentState = MobileVerificationState.OTP_FORM;
                      this.verificationId = verificationId;
                      loading = false;
                    });
                  });
            },
            child: const Text("Verify")),
        const Spacer()
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: otpController,
          decoration: const InputDecoration(hintText: "OTP"),
        ),
        const SizedBox(
          height: 16,
        ),
        FlatButton(
            onPressed: () async {
              auth.signInWithPhoneAuthCredential(verificationId, otpController.text,
                  (userCredential, errorMsg) {
                print(userCredential);
                setState(() {
                  loading = false;
                });

                if (userCredential != null && userCredential.user != null) {
                  widget.setUser(userCredential.user);
                } else {
                  _scaffoldKey.currentState?.showSnackBar(
                      SnackBar(content: Text(errorMsg)));
                }
              });
            },
            child: const Text("Verify")),
        const Spacer(),
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
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.MOBILE_FORM
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
        ));
  }
}
