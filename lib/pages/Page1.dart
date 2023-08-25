import 'dart:developer';
import 'dart:io';
import 'package:app/Utils.dart';
import 'package:app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  final Color kDarkBlueColor = const Color(0xFF053149);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  String Product = '';
  String Qkg = '';
  String Dod = '';
  String Dor = '';
  String pincode = '';
  String city = '';
  String region = '';
  TextEditingController _controller = new TextEditingController();
  TextEditingController Region = new TextEditingController();

  void Fetchlocation(
      {required pin, required loadingProvider, required context}) async {
    try {
      var url = Uri.https('api.postalpincode.in', '/pincode/${pin}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        Map a = jsonResponse[0]['PostOffice'][0];
        if (a.isNotEmpty) {
          setState(() {
            print("gomaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
          });
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print(e);
      loadingProvider.toggleLoading();
    }
  }

  Widget build(BuildContext context) {
    final loadingProvider = Provider.of<LoadingProvider>(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: loadingProvider.isLoading
          ? Container()
          : Column(
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
                Container(
                  height: height * 0.55,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blueGrey[50],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        offset: Offset(-3, -3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        offset: Offset(3, 3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: TextField(
                            keyboardType: TextInputType.text,
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
                                  initialDate:
                                      DateTime.now(), //get today's date
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2101));
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                String FormatDor = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now());

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
                              print(value);
                              if (value.length == 6) {
                                loadingProvider.toggleLoading();

                                Fetchlocation(
                                    pin: value,
                                    loadingProvider: loadingProvider,
                                    context: context);
                              }
                            },
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
                          onPressed: () {},
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    ));
  }
}
