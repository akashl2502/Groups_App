import 'dart:io';
import 'package:Hopnmove/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class Page2 extends StatefulWidget {
  const Page2({required this.uid});
  final String uid;
  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool _isloading = false;

  final FBstorage = FirebaseStorage.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool delcon = false;
  void _pickFile({required filename, required docid, required context}) async {
    PermissionStatus permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          setState(() {
            _isloading = true;
          });
          File selectedFile = File(result.files.single.path!);

          Reference storageRef = FBstorage.child(
              'files/${DateTime.now().millisecondsSinceEpoch}.pdf');

          await storageRef.putFile(selectedFile);

          String downloadURL = await storageRef.getDownloadURL();
          await _firestore
              .collection('orderdetails')
              .doc(docid)
              .update({filename: downloadURL}).then((value) {
            setState(() {
              _isloading = false;
            });
            ShowSnackbar(context, 'Document Successfully Added');
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          _isloading = false;
        });
        ShowSnackbar(context, e.toString());
      }
    } else {
      ShowSnackbar(context, 'storage access denied');
    }
  }

  void showDeleteConfirmation(
      BuildContext context, String docId, file1, file2) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Text('Are you sure you want to delete this request?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _isloading = true;
                });
                Deldata(context, docId, file1, file2);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> Deldata(BuildContext context, String docId, file1, file2) async {
    try {
      if (file1.toString().length != 0) {
        Reference storageRef = FirebaseStorage.instance.refFromURL(file1);
        await storageRef.delete();
      }
      if (file2.toString().length != 0) {
        Reference storageRef = FirebaseStorage.instance.refFromURL(file2);
        await storageRef.delete();
      }
      await _firestore
          .collection('orderdetails')
          .doc(docId)
          .delete()
          .then((value) {
        setState(() {
          _isloading = false;
        });
        ShowSnackbar(context, 'Data Successfully Deleted');
      });
    } catch (e) {
      print(e);
      setState(() {
        _isloading = false;
      });
      ShowSnackbar(context, 'Error in deleting requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> _ordersStream =
        FirebaseFirestore.instance
            .collection('orderdetails')
            .where('uid', isEqualTo: widget.uid)
            .where('status', isEqualTo: 0)
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
                children: [Center(child: Text('No Request Available.'))],
              ));
          ;
        }

        final orderDocs = snapshot.data!.docs;
        List<DataRow> dataRows = [];

        for (int index = 0; index < orderDocs.length; index++) {
          final orderDoc = orderDocs[index];
          final orderData = orderDoc.data() as Map<String, dynamic>;
          print(orderData);

          dataRows.add(DataRow(cells: [
            DataCell(Text('${index + 1}')), // Displaying the index
            DataCell(Text(orderData['dor'])),
            DataCell(Text(orderData['product'])),
            DataCell(Text(orderData['quantity'])),
            DataCell(Text(orderData['dod'])),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.upload_file),
                    onPressed: () {
                      _pickFile(
                          filename: 'file1',
                          context: context,
                          docid: orderDoc.id);
                    },
                  ),
                  SizedBox(height: 20),
                  Text(orderData['file1'].toString().length == 0
                      ? 'No file Uploaded'
                      : 'File Successfully Uploaded'),
                ],
              ),
            ),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.upload_file),
                    onPressed: () {
                      _pickFile(
                          filename: 'file2',
                          context: context,
                          docid: orderDoc.id);
                    },
                  ),
                  SizedBox(height: 20),
                  Text(orderData['file2'].toString().length == 0
                      ? 'No file Uploaded'
                      : "File Successfully Uploaded"),
                ],
              ),
            ),
            DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    showDeleteConfirmation(context, orderDoc.id,
                        orderData['file1'], orderData['file2']);
                  },
                )
              ],
            )),
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
                        "Upcoming Records",
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
                            label: Text('Doc1'),
                          ),
                          DataColumn(
                            label: Text('Doc2'),
                          ),
                          DataColumn(
                            label: Text('Action'),
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
