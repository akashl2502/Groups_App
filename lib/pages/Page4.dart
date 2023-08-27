import 'dart:developer';
import 'dart:io';
import 'package:Hopnmove/Utils.dart';
import 'package:Hopnmove/main.dart';
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

class Page4 extends StatefulWidget {
  const Page4({required this.uid, required this.buyer});
  final String uid;
  final bool buyer;

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _ordersStream =
        widget.buyer
            ? FirebaseFirestore.instance
                .collection('orderdetails')
                .where('buyeruid', isEqualTo: widget.uid)
                .where('status', isEqualTo: 2)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('orderdetails')
                .where('uid', isEqualTo: widget.uid)
                .where('status', isEqualTo: 2)
                .snapshots();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _ordersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              )),
              body: Column(
                children: [Center(child: Text('Error: ${snapshot.error}'))],
              )); // If there's an error
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              )),
              body: Column(
                children: [Center(child: Text('No Past Request Available.'))],
              ));
        }

        final orderDocs = snapshot.data!.docs;
        List<DataRow> dataRows = [];

        for (int index = 0; index < orderDocs.length; index++) {
          final orderDoc = orderDocs[index];
          final orderData = orderDoc.data() as Map<String, dynamic>;
          print(orderData);
          dataRows.add(DataRow(cells: [
            DataCell(Text('${index + 1}')),
            DataCell(Text(orderData['dor'])),
            DataCell(Text(orderData['product'])),
            DataCell(Text(orderData['quantity'])),
            DataCell(Text(orderData['dod'])),
            DataCell(Text(orderData['pincode'] +
                ',' +
                ' ' +
                orderData['city'] +
                ' ' +
                ',' +
                orderData['region'])),
          ]));
        }
        return ModalProgressHUD(
          inAsyncCall: _isloading,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                  leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              )),
              body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        "Completed Records",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(columns: [
                          DataColumn(
                            label: Text('Serial.No'),
                          ),
                          DataColumn(
                            label: Text('Date of Request'),
                          ),
                          DataColumn(
                            label: Text('Product'),
                          ),
                          DataColumn(
                            label: Text('Quantity (KG)'),
                          ),
                          DataColumn(
                            label: Text('Date of Dispatch'),
                          ),
                          DataColumn(
                            label: Text('Pincode,City'),
                          ),
                        ], rows: dataRows)),
                    SizedBox(
                      height: 30,
                    )
                  ])),
        );
      },
    );
  }
}
