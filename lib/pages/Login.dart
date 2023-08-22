import 'package:app/pages/Home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:otp_fields/otp_fields.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Color kDarkBlueColor = const Color(0xFF053149);
  bool _showPhoneNumberScreen = false;
  bool _showOtpScreen = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      width: width * 0.7,
                      child: TextField(
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
                          onPressed: _toggleOTPScreen,
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      width: width * 0.9,
                      child: OtpFieldsCustom(
                          context: context,
                          numberOfFields: 6,
                          onCodeChanged: (otp) {}),
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home()));
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
                          onPressed: _togglePhoneScreen,
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
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 13),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
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
