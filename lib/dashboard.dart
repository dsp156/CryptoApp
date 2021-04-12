import 'package:cloud_firestore/cloud_firestore.dart';
import 'helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'logic.dart';

Logic logic = new Logic();
String result;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool valuefirst = false;
  Helper _helper = Helper();
  final _formKey = GlobalKey<FormState>();
  String _name, _pass, _catagory;

  Future<bool> _addData() async {
    User _user = FirebaseAuth.instance.currentUser;
    Map<String, dynamic> data = {
      'userId': _user.uid.toString(),
      'Catagory': _catagory,
      'UserName': _name,
      'Password': result,
    };
    await FirebaseFirestore.instance
        .collection('Cryptography_password_save')
        .doc(_user.uid)
        .collection('credentials')
        .add(data)
        .then((value) async {
      print("Data added");
    }).catchError((e) {
      print(e);
      _helper.show("Opps!! Some error occured. Try again");
      _helper.flushbar..show(context);
      return false;
    });
    return true;
  }

  Widget _body() {
    return Card(
      elevation: 5.0,
      color: Colors.black,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 1.0),
          borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Catagory",
                        labelStyle: TextStyle(backgroundColor: Colors.white),
                        filled: true,
                        hintText: "Enter catagory",
                        prefixIcon: Icon(
                          Icons.add,
                          size: 30.0,
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(8.0)))),
                    validator: (value) {
                      if (value.toString().length == 0) {
                        return "Catagory not be zero";
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        _catagory = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "User Name",
                        labelStyle: TextStyle(backgroundColor: Colors.white),
                        filled: true,
                        hintText: "Enter User Name",
                        prefixIcon: Icon(
                          Icons.person,
                          size: 30.0,
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(8.0)))),
                    validator: (value) {
                      if (value.toString().length == 0) {
                        return "Catagory not be zero";
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        _name = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(backgroundColor: Colors.white),
                        filled: true,
                        hintText: "Enter Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          size: 30.0,
                        ),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(8.0)))),
                    validator: (value) {
                      if (value.toString().length == 0) {
                        return "Password not be zero";
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        _pass = value;
                      });
                    },
                  ),
                  FlatButton(
                      color: Colors.blue,
                      splashColor: Colors.white,
                      highlightColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.blue, width: 1.0),
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        result = logic.railfenceEncrypt(_pass, 2);
                        if (_formKey.currentState.validate()) {
                          FocusScope.of(context).unfocus();
                          _addData().then((_) {
                            Navigator.of(context).pop("Your data is uploaded");
                          });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Upload Data",
                            style: TextStyle(
                              color: Colors.white,
                              // backgroundColor: Colors.blueGrey
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.upload_sharp,
                            color: Colors.white,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      body: _body(),
    );
  }
}
