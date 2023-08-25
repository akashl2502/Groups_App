import 'package:app/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_loader/easy_loader.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'Home.dart';

class Newuser extends StatefulWidget {
  const Newuser({super.key, required this.UID});
  final String UID;
  @override
  State<Newuser> createState() => _NewuserState();
}

class _NewuserState extends State<Newuser> {
  @override
  void initState() {
    box = Hive.box('Data');
    Mobnum.text = box.get('num');

    Checkuser(uid: widget.UID);
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  late final Box box;

  final Color kDarkBlueColor = const Color(0xFF053149);
  ScrollController _scrollController = ScrollController();
  String dropdownvalue = 'Seller';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isloading = true;
  String name = '';
  String Compname = '';
  String Email = '';
  String MobNum = '';
  String Gstno = '';
  TextEditingController Mobnum = TextEditingController();

  Future<void> Checkuser({required uid}) async {
    CollectionReference _cat = _firestore.collection("Userdetails");
    Query query = _cat.where("uid", isEqualTo: uid);
    QuerySnapshot querySnapshot = await query.get();
    final _docData = querySnapshot.docs.map((doc) => doc.data()).toList();

    if (_docData.isNotEmpty) {
      setState(() async {
        await box.put('AU', true);
        await box.put('data', _docData[0]);
        await box.put('UB', true);
        await box.put('uid', uid).then((value) => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            UID: uid,
                          )))
            });
      });
    } else {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: _isloading
            ? EasyLoader(image: AssetImage('assets/logo.png'))
            : SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome To Hop N Move !",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueColor),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Please Enter Details ",
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
                              onChanged: (value) => {name = value},
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                hintText: 'Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: TextField(
                              onChanged: (value) => {Compname = value},
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Company Name',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                hintText: 'Company Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: TextField(
                              onChanged: (value) => {Email = value},
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                hintText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: TextField(
                              onChanged: (value) => {MobNum = value},
                              keyboardType: TextInputType.number,
                              enabled: false,
                              controller: Mobnum,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                hintText: 'Mobile Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: TextField(
                              onChanged: (value) => {Gstno = value},
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'GST No',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                hintText: 'GST No',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                border: OutlineInputBorder(),
                              ),
                              value: dropdownvalue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                              items: <String>[
                                'Seller',
                                'Buyer'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          MaterialButton(
                            color: kDarkBlueColor,
                            textColor: Colors.white,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                            onPressed: () async {
                              Pushuserdata();
                            },
                            child: Text("Submit"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void Pushuserdata() {
    if (name.isNotEmpty &&
        Compname.isNotEmpty &&
        Email.isNotEmpty &&
        Mobnum.text.isNotEmpty &&
        Gstno.length == 15 &&
        dropdownvalue.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      var data = {
        'company': Compname,
        'email': Email,
        'gst': Gstno,
        'mob': Mobnum.text,
        'name': name,
        'type': dropdownvalue,
        'uid': widget.UID
      };
      _firestore.collection("Userdetails").add(data).then((value) async {
        await box.put('AU', true);
        await box.put('data', data);
        await box.put('UB', true);
        await box.put('uid', widget.UID).then((value) {
          setState(() {
            _isloading = false;
          });
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Home(
                        UID: widget.UID,
                      )));
        });
      });
    } else {
      if (Gstno.length != 15) {
        ShowSnackbar(context, "GST number must be 15 Digits");
      } else if (MobNum.length != 10) {
        ShowSnackbar(context, "Invalid Mobile Number");
      } else {
        ShowSnackbar(context, "Fill All Necessary Details");
      }
    }
  }
}
