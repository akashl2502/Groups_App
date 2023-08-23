// ignore_for_file: use_build_context_synchronously

import 'package:app/Utils.dart';
import 'package:app/pages/Home.dart';
import 'package:app/pages/Newuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:otp_fields/otp_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_loader/easy_loader.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Color kDarkBlueColor = const Color(0xFF053149);
  bool _showPhoneNumberScreen = false;
  bool _showOtpScreen = false;
  String phonenumber = '';
  String VID = '';
  String OTP = '';
  bool _Isloading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _Isloading
            ? EasyLoader(image: AssetImage('assets/logo.png'))
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/login.json'),
                  if (_showPhoneNumberScreen)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Enter Your Phone Number",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Container(
                            width: width * 0.7,
                            child: TextField(
                              onChanged: (value) =>
                                  {phonenumber = value.trim()},
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MaterialButton(
                                color: kDarkBlueColor,
                                textColor: Colors.white,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                onPressed: () => {
                                  if (phonenumber.length == 10)
                                    {Checkuser(number: phonenumber)}
                                  else
                                    {
                                      ShowSnackbar(context,
                                          "Given Mobile Number is Invalid")
                                    }
                                },
                                child: Text("Get OTP"),
                              ),
                              MaterialButton(
                                color: kDarkBlueColor,
                                textColor: Colors.white,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                onPressed: _showInitialScreen,
                                child: Text("Back"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else if (_showOtpScreen)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Enter Your OTP",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Container(
                            width: width * 0.9,
                            child: OtpFieldsCustom(
                                context: context,
                                numberOfFields: 6,
                                onCodeChanged: (otp) {
                                  setState(() {
                                    OTP = otp.trim();
                                  });
                                }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MaterialButton(
                                color: kDarkBlueColor,
                                textColor: Colors.white,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                onPressed: () {
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => Newuser()));
                                  if (OTP.trim().length == 6) {
                                    VerifyOtp(
                                        context: context,
                                        UserOtp: OTP,
                                        verificationId: VID);
                                  } else {
                                    ShowSnackbar(context, "Invalid Otp Pin");
                                  }
                                },
                                child: Text("Submit OTP"),
                              ),
                              MaterialButton(
                                color: kDarkBlueColor,
                                textColor: Colors.white,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPhoneNumberScreen = true;
                                    _showOtpScreen = false;
                                  });
                                },
                                child: Text("Back"),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Not Recieved OTP Yet ?",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 13),
                              ),
                              SizedBox(height: 8),
                              InkWell(
                                  child: new Text(
                                    'Resend !',
                                    style: TextStyle(
                                        color: Colors.red,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onTap: () => launch(
                                      'https://docs.flutter.io/flutter/services/UrlLauncher-class.html')),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: width * 0.9,
                      child: MaterialButton(
                        color: kDarkBlueColor,
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: _togglePhoneScreen,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.phone, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Sign In With Phone Number",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  Future<void> VerifyOtp(
      {required BuildContext context,
      required String UserOtp,
      required String verificationId}) async {
    try {
      setState(() {
        _Isloading = true;
      });
      PhoneAuthCredential Cred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: UserOtp);
      User user = (await _auth.signInWithCredential(Cred)).user!;
      if (user != null) {
        setState(() {
          _Isloading = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Newuser(UID: user.uid)));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _Isloading = false;
      });
      ShowSnackbar(context, e.message.toString());
    }
  }

  void Verifyphonenumber(BuildContext context, String phonenumber) async {
    setState(() {
      _Isloading = true;
    });
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: '+91${phonenumber}',
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _auth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (err) {
            throw Exception(err.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            setState(() {
              _Isloading = false;
              VID = verificationId;
              _showPhoneNumberScreen = false;
              _showOtpScreen = true;
            });
          },
          codeAutoRetrievalTimeout: (VerificationId) {});
    } on FirebaseAuthException catch (e) {
      setState(() {
        _Isloading = false;
      });
      ShowSnackbar(context, e.message.toString());
    }
  }

  Future<void> Checkuser({required number}) async {
    setState(() {
      _Isloading = true;
    });
    CollectionReference _cat = _firestore.collection("seller");
    Query query = _cat.where("number", isEqualTo: number);
    QuerySnapshot querySnapshot = await query.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();
    if (_docData.isNotEmpty) {
      Verifyphonenumber(context, phonenumber);
    } else {
      setState(() {
        _Isloading = false;
      });
      ShowSnackbar(context, "No Access For This Number");
    }
  }

  void _togglePhoneScreen() {
    setState(() {
      _showPhoneNumberScreen = true;
      _showOtpScreen = false;
    });
  }

  void _toggleOTPScreen() {
    setState(() {
      _showPhoneNumberScreen = false;
      _showOtpScreen = true;
    });
  }

  void _showInitialScreen() {
    setState(() {
      _showPhoneNumberScreen = false;
      _showOtpScreen = false;
    });
  }
}
