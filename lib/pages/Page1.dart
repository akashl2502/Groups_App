import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../Utils.dart';

class Page1 extends StatefulWidget {
  const Page1({required this.uid});
  final String uid;

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final Color kDarkBlueColor = const Color(0xFF053149);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  TextEditingController Product = TextEditingController();
  TextEditingController Qkg = TextEditingController();
  String Dod = '';
  String Dor = '';
  TextEditingController pincode = TextEditingController();
  String city = '';
  String region = '';
  TextEditingController _controller = TextEditingController();
  TextEditingController Region = TextEditingController();
  bool _isloading = false;
  void Fetchlocation({required pin, required context}) async {
    setState(() {
      _isloading = true;
    });
    try {
      var url = Uri.https('api.postalpincode.in', '/pincode/${pin}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        List a = jsonResponse[0]['PostOffice'];
        if (a.isNotEmpty) {
          setState(() {
            city = a[0]['Name'];
            region = a[0]["District"];
            Region.text = a[0]['Name'] + a[0]["District"];
            _isloading = false;
          });
        } else {
          ShowSnackbar(context, "Invalid Pincode");
        }
      } else {
        setState(() {
          Region.text = "";

          _isloading = false;
        });
        ShowSnackbar(context, "Error Fetching Your Location");

        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      setState(() {
        Region.text = "";

        _isloading = false;
      });
      ShowSnackbar(context, "Error Please Try again later");

      print(e);
    }
  }

  void Pushdata({required context}) async {
    if (Product.text.isNotEmpty &&
        Qkg.text.isNotEmpty &&
        Dod.isNotEmpty &&
        Dor.isNotEmpty &&
        pincode.text.isNotEmpty &&
        region.isNotEmpty) {
      var data = {
        'buyeruid': '',
        'city': city,
        'dod': Dod,
        'dor': Dor,
        'file1': '',
        'file2': '',
        'pincode': pincode.text,
        'product': Product.text,
        'quantity': Qkg.text,
        'read': 0,
        'region': region,
        'status': 0,
        'uid': widget.uid,
      };
      await _firestore.collection('orderdetails').add(data).then((value) {
        setState(() {
          Product.clear();
          Qkg.clear();
          pincode.clear();
          _controller.clear();
          Region.clear();
          _isloading = false;
        });
        ShowSnackbar(context, "Request Successfully Updated");
      }).catchError((err) {
        log(err);
        ShowSnackbar(context, "Error While Requesting Service");
      });
    } else {
      ShowSnackbar(context, "Fill All the Details");
    }
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _isloading,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back ! ",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlueColor),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Please Enter ",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: Product,
                        decoration: InputDecoration(
                          labelText: 'Product',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          hintText: 'Product',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        controller: Qkg,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity in KGS...',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          hintText: 'Quantity in KGS...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        controller: _controller,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(), //get today's date
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            String FormatDor =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());

                            setState(() {
                              _controller.text = formattedDate;
                              Dod = formattedDate;
                              Dor = FormatDor;
                            });
                          } else {}
                        },
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: 'Date of Dispatch',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          hintText: 'Date of Dispatch',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        onChanged: (value) {
                          pincode.text = value;
                          if (value.length == 6) {
                            Fetchlocation(pin: value, context: context);
                          }
                        },
                        controller: pincode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Pin Code',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          hintText: 'Pin Code',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        enabled: false,
                        controller: Region,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Region,City',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          hintText: 'Region,City',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    MaterialButton(
                      color: kDarkBlueColor,
                      textColor: Colors.white,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      onPressed: () {
                        Pushdata(context: context);
                      },
                      child: Text("Submit"),
                    ),
                    SizedBox(
                      height: 300,
                    ),
                  ],
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
