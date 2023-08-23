import 'package:flutter/material.dart';

class Newuser extends StatefulWidget {
  const Newuser({super.key});

  @override
  State<Newuser> createState() => _NewuserState();
}

class _NewuserState extends State<Newuser> {
  final Color kDarkBlueColor = const Color(0xFF053149);
  ScrollController _scrollController = ScrollController();
  String dropdownvalue = 'Seller';
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
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
                        keyboardType: TextInputType.number,
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
                        keyboardType: TextInputType.datetime,
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
                        keyboardType: TextInputType.text,
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
                        keyboardType: TextInputType.text,
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
                        items: <String>['Seller', 'Buyer']
                            .map<DropdownMenuItem<String>>((String value) {
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
                      onPressed: () {},
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
}
