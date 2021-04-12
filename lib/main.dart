import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoapp/helper.dart';
import 'package:cryptoapp/logic.dart';
import 'package:cryptoapp/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Logic logic = new Logic();
  String result;
  Helper _helper = Helper();
  String _name;
  String _email;
  String _uid;
  User _user;
  bool _isLoading = false;
  String _url =
      "https://png.pngitem.com/pimgs/s/506-5067022_sweet-shap-profile-placeholder-hd-png-download.png";

  void _signIn() {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()))
        .then((value) {
      if (value != null) {
        if (mounted)
          setState(() {
            _user = FirebaseAuth.instance.currentUser;
          });
        _getDetails().then((_) {
          _profileUrl();
        });
        _helper.show(value);
        _helper.flushbar.show(context);
      }
    });
  }

  Future<void> _signOut() async {
    Navigator.of(context).pop();
    await FirebaseAuth.instance.signOut().then((value) {
      print("User logged out");
      _helper.show("You are logged out:)");
      _helper.flushbar.show(context);
      setState(() {
        _user = null;
      });
      _getDetails().then((_) {
        _profileUrl();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _getDetails() async {
    if (_user != null && _user.emailVerified) {
      await FirebaseFirestore.instance
          .collection('cryptography')
          .doc(_user.uid)
          .get()
          .then((value) {
        setState(() {
          _name = value.data()['Name'];
          _email = _user.email;
          _uid = _user.uid;
        });
        print(_name);
        print(_email);
      }).catchError((e) {
        print(e);
      });
    } else {
      setState(() {
        _name = null;
        _email = null;
        _uid = null;
      });
    }
  }

  Future<void> _profileUrl() async {
    if (_user != null && _user.emailVerified) {
      await FirebaseFirestore.instance
          .collection('cryptography')
          .doc(_uid)
          .get()
          .then((value) {
        // print(value.data().containsKey('profileUrl'));
        if (value.data().containsKey('profileUrl') == true) {
          setState(() {
            _url = value.data()['profileUrl'].toString();
          });
        }
        print(_url);
      });
    } else {
      setState(() {
        _url =
            "https://png.pngitem.com/pimgs/s/506-5067022_sweet-shap-profile-placeholder-hd-png-download.png";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _user = FirebaseAuth.instance.currentUser;
    if (_user == null || _user.emailVerified == false) {
      setState(() {
        _user = null;
      });
    }
    _getDetails().then((_) async {
      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
    });
    print(_name);
    print(_email);
    print(_uid);
  }

  Widget _drawer() {
    return _isLoading
        ? _helper.spinkit
        : Drawer(
            child: Container(
              color: Colors.black,
              child: ListView(
                children: <Widget>[
                  _uid != null
                      ? UserAccountsDrawerHeader(
                          accountName: Text(
                            _name,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          accountEmail: Text(
                            _email,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          currentAccountPicture: FlutterLogo())
                      : Container(),
                  _uid != null
                      ? ListTile(
                          title: Text(
                            "My Profile",
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onTap: () {
                            // Navigator.of(context).pop();
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(
                            //         builder: (context) => UserProfile()))
                            //     .then((_) {
                            //   _profileUrl();
                            //   _getDetails();
                            // });
                          },
                        )
                      : Container(),
                  Divider(
                    color: Colors.blue,
                    height: 0.0,
                  ),
                  ListTile(
                    title: Text(
                      _uid != null ? "Logout" : "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.white,
                    ),
                    onTap: () => _uid == null ? _signIn() : _signOut(),
                  ),
                  Divider(
                    color: Colors.blue,
                    height: 0.0,
                  ),
                  ListTile(
                    title: Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Divider(
                    color: Colors.blue,
                    height: 0.0,
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cryptography app"),
      ),
      drawer: _drawer(),
      body: _uid != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Cryptography_password_save')
                  .doc(_user.uid)
                  .collection('credentials')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text('Something went wrong',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          )));
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Loading...",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        )),
                  );
                }
                if (snapshot.data.docs.length == 0) {
                  return Center(
                    child: Text(
                      "There are not any blogs to show",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return Container(
                  color: Colors.blueGrey[200],
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot student = snapshot.data.docs[index];
                      // print(block);
                      // result = logic.railfenceDecrypt(student['Password'], 2);
                      print(student['UserName']);
                      // print(result);
                      return Card(
                        elevation: 10.0,
                        color: Colors.lightBlue[100],
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(
                            'Catagory :- ' + student['Catagory'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'UserName :- ' +
                                  student['UserName'] +
                                  " " +
                                  '\n' +
                                  'Password :- ' +
                                  logic.railfenceDecrypt(
                                      student['Password'], 2),
                              style: TextStyle(
                                  fontWeight: FontWeight
                                      .bold)), //snapshot data should dispaly in this text field
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        onPressed: () {
          if (_uid != null) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Dashboard()))
                .then((value) {
              if (value != null) {
                _helper.show(value);
                _helper.flushbar.show(context);
              }
            });
          } else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Login()))
                .then((value) {
              if (value != null) {
                if (mounted)
                  setState(() {
                    _user = FirebaseAuth.instance.currentUser;
                  });
                _getDetails().then((_) {
                  _profileUrl();
                });
                _helper.show(value);
                _helper.flushbar.show(context);
              }
            });
          }
        },
        splashColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        highlightElevation: 10.0,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // body: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     RaisedButton(
      //       onPressed: () => Navigator.of(context).push(
      //           MaterialPageRoute(builder: (BuildContext context) => SignUp())),
      //       child: Text("Signup"),

      //     )
      //   ],
      // ),
    );
  }
}
