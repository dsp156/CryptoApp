// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cryptography/helper.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'dashboard.dart';

// class SignUp extends StatefulWidget {
//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   Helper _helper = Helper();
//   Future <void> _register() async{
//     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _pass).then((_user)
//     async {
//       await FirebaseFirestore.instance.collection("cryptography").doc(_user.user.uid).set({
//         "Email":_email,
//         "Name":_name,
//       }).then((_)=>print("Successfully added to database"));
//     }
//     ).catchError((signUpError) {
//       print(signUpError.code.toString());
//       if(signUpError.code.toString() == "email-already-in-use")
//       {
//         print(signUpError.code.toString());
//         _helper.show("The account already exists for that email.");
//         _helper.flushbar.show(context);
//       }
//       else if(signUpError.code.toString() == "weak-password")
//       {
//         _helper.show("The password provided is too weak.!!");
//         _helper.flushbar.show(context);
//       }
//       else if(signUpError.code.toString() == "invalid-email")
//       {
//         _helper.show("The email provided is invalid!!");
//         _helper.flushbar.show(context);
//       }
//       else
//       {
//         _helper.show("something went wrong!!");
//         _helper.flushbar.show(context);
//       }
//     });
//   }

//   String _pass;
//   String _email;
//   String _name;
//   final _formKey = GlobalKey<FormState>();

//    Widget _body()
//   {
//     return Card(
//       elevation: 5.0,
//       color: Colors.black,
//       margin: EdgeInsets.all(4.0),
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: Colors.blue, width: 1),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(16.0,32.0,16.0,32.0),
//           child: Center(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Icon(
//                     Icons.account_circle,
//                     color: Colors.white,
//                     size: 100,
//                   ),
//                   SizedBox(height: 15.0,),
//                   TextFormField(
//               decoration: InputDecoration(
//                 hintText: "Enter Name",
//                 prefixIcon: Icon(
//                   Icons.account_circle,
//                   size: 30,
//                 ),
//                 fillColor: Colors.white,
//                 filled: true,
//               ),
//               validator: (value){
//                 if (value.toString().length == 0) {
//                   return "Name can not be empty!";
//                     }
//                   },
//               onChanged: (value)=>{
//                 setState((){

//                 _name=value;
//                 })
//               },
//             ),
//             SizedBox(height: 10.0,),
//             TextFormField(
//               decoration: InputDecoration(
//                 hintText: "Enter Email",
//                 prefixIcon: Icon(
//                   Icons.email,
//                   size: 30,
//                 ),
//                 fillColor: Colors.white,
//                 filled: true,
//               ),
//               validator: (value) {
//                       if (EmailValidator.validate(value) == false) {
//                         return "Enter correct email";
//                       }
//                     },
//               onChanged: (value)=>{
//                 setState((){
//                 _email=value;
//                 })
//               },
//             ),
//             SizedBox(height: 10.0,),
//             TextFormField(
//               // controller: _enController,
//               decoration: InputDecoration(
//                 hintText: "Enter Enrollment Number",
//                 prefixIcon: Icon(
//                   Icons.engineering_outlined,
//                   size: 30,
//                 ),
//                 fillColor: Colors.white,
//                 filled: true,
//               ),
//               validator: (value){
//                 if (value.toString().length == 0) {
//                   return "Name can not be empty!";
//                     }
//                   },
//               onChanged: (value)=>{
//                 setState((){
//                 _pass=value;
//                 })
//               },
//             ),

//                   SizedBox(
//                     height: 40.0,
//                   ),
//                   FlatButton(
//                     color: Colors.blue,
//                     splashColor: Colors.white,
//                     highlightColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(color: Colors.blue, width: 1),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     height:40.0,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Add Student",
//                           style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(width: 10.0,),
//                         Icon(
//                           Icons.person_add_outlined,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                     onPressed: () {
//                       _register().then((_){
//                         Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>Dashboard()));
//                       });
//                       // // if (_formKey.currentState.validate()) {
//                       // //   FocusScope.of(context).unfocus();
//                       //   _register().then((_){
//                       //     // print(_isLoading);
//                       //     // if(_isLoading==false)
//                       //     // {
//                       //     //   print(_isLoading);
//                       //       Navigator.of(context).pop(
//                       //         "Hey, verify your email via link sent in the mail and the login"
//                       //       );
//                       //     // }
//                       //     // else
//                       //     // {
//                       //     //   setState(() {
//                       //     //     _isLoading=false;
//                       //     //   });
//                       //     // }
//                       //   });
//                       // // FirebaseFirestore.instance.collection("Hostel").doc(_enNo).set(
//                       // // {
//                       // //   'name': _name,
//                       // //   'email': _email,
//                       // //   'Enrollment No':_enNo,
//                       // //   'Block':_block,
//                       // //   'Room No':_roomNo,
//                       // //   'Mobile No':_moNo,
//                       // //   }
//                       // // ).then((value){
//                       // //   print("Successfully added to database");
//                       // // });
//                     }

//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Sign up"),
//       ),
//       body: Center(
//         child: SingleChildScrollView(child: _body(),),
//       )
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cryptoapp/helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String _email, _pass, _name;
  bool _eyeClosed = true, _isLoading = false;
  Helper _helper = Helper();
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: _email, password: _pass)
        .then((_user) async {
      await _user.user.sendEmailVerification().then((_) async {
        await FirebaseFirestore.instance
            .collection("cryptography")
            .doc(_user.user.uid)
            .set({
          "Name": _name,
          "Email": _email,
        }).then((_) {
          print("Successfully added to database");
          setState(() {
            _isLoading = false;
          });
        }).catchError((e) {
          print(e);
        });
      }).catchError((e) {
        print("An error occured while trying to send email verification");
        print(e.message);
        _helper
            .show("An error occured while trying to send email verification");
        _helper.flushbar.show(context);
      });
    }).catchError((signUpError) {
      print(signUpError.code.toString());
      if (signUpError.code.toString() == "email-already-in-use") {
        print(signUpError.code.toString());
        _helper.show("The account already exists for that email.");
        _helper.flushbar.show(context);
      } else if (signUpError.code.toString() == "weak-password") {
        _helper.show("The password provided is too weak.!!");
        _helper.flushbar.show(context);
      } else if (signUpError.code.toString() == "invalid-email") {
        _helper.show("The email provided is invalid!!");
        _helper.flushbar.show(context);
      } else {
        _helper.show("something went wrong!!");
        _helper.flushbar.show(context);
      }
    });
  }

  Widget _body() {
    return Card(
      elevation: 5.0,
      color: Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 32.0),
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 100,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Enter Name",
                          labelText: "Name",
                          labelStyle: TextStyle(backgroundColor: Colors.white),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.perm_identity_sharp,
                            size: 30.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8.0)))),
                      validator: (value) {
                        if (value.toString().length == 0) {
                          return "Name can not be empty!";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Enter Email",
                          labelText: "Email",
                          labelStyle: TextStyle(backgroundColor: Colors.white),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.email,
                            size: 30.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8.0)))),
                      validator: (value) {
                        if (EmailValidator.validate(value) == false) {
                          return "Enter correct email";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          hintText: "Enter password",
                          labelText: "Password",
                          labelStyle: TextStyle(backgroundColor: Colors.white),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 30.0,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_eyeClosed == true
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () => setState(() {
                              if (_eyeClosed == true) {
                                _eyeClosed = false;
                              } else {
                                _eyeClosed = true;
                              }
                            }),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8.0)))),
                      obscureText: _eyeClosed,
                      validator: (value) {
                        if (value.toString().length == 0) {
                          return "Password can not be empty";
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          _pass = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    FlatButton(
                        color: Colors.blue,
                        splashColor: Colors.white,
                        highlightColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            _register().then((_) {
                              if (_isLoading == false) {
                                Navigator.of(context).pop(
                                    "Hey, verify your email via link sent in the mail and the login");
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.blue, width: 1.0),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Register",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Icon(
                              Icons.person_add_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: SingleChildScrollView(
        child: _body(),
      )),
    );
  }
}
