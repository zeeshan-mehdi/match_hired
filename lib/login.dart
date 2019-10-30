import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:match_hire/home.dart';
import 'package:match_hire/main.dart' as prefix0;
import 'package:match_hire/model/User.dart';
import 'package:match_hire/upload_image.dart';

class LoginScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Hired',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String title = "Login";
  static List<User> users = new List<User>();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  final _formKey = GlobalKey<FormState>();

  /// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber(context) async {
    if (_formKey.currentState.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.

    } else {
      return;
    }

    PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) {
      setState(() {
        print('verification completed');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;

      Fluttertoast.showToast(msg: 'code sent');
      print("code sent to " + _phoneNumberController.text);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;

      Fluttertoast.showToast(msg: 'time out');
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user =
        await _auth.signInWithCredential(credential).then((user) {
      if (user == null) {
        throw Exception();
      }

      print('user id ${user.uid}');

      filterUsers(user.uid);

      Fluttertoast.showToast(msg: 'Sign In Successfull');

      checkUserProfilePic(user);
    }).catchError((e) {
      Fluttertoast.showToast(msg: 'Sign In Failed');
      print(e);
    });
  }

  @override
  void initState() async{
    // TODO: implement initState
    await fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Login To Match Hired',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Container(
              height: 50,
            ),
            Padding(
              child: TextFormField(
                controller: _phoneNumberController,
                decoration: new InputDecoration(
                  labelText: "Enter Phone Number with country code",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if (val.length == 0) {
                    return "Phone Number cannot be empty";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              padding: EdgeInsets.all(8),
            ),
            Padding(
              child: TextFormField(
                controller: _smsCodeController,
                decoration: new InputDecoration(
                  labelText: "Enter verification code ",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              padding: EdgeInsets.all(8),
            ),
            Padding(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      color: Theme.of(context).accentColor,
                      onPressed: () =>
                          _signInWithPhoneNumber(_smsCodeController.text),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ))),
              padding: EdgeInsets.all(8),
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _sendCodeToPhoneNumber(context),
        tooltip: 'get code',
        child: new Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void fetchUsers() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('users').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length != 0) {
      documents.forEach((snapshot) {
        User user = new User(snapshot['id'], snapshot['nickname'],
            snapshot['photoUrl'], snapshot['country']);
        LoginPage.users.add(user);
      });
    } else {
      Fluttertoast.showToast(msg: 'No Other User is Registered');
    }
  }

  void filterUsers(String uid) {
    for (var i = 0; i < LoginPage.users.length; i++) {
      if (LoginPage.users[i].id == uid) {
        LoginPage.users.removeAt(i);
      }
    }
  }

  void checkUserProfilePic(user) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('id', isEqualTo: user.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;

    if (documents.length > 0) {
      if (documents[0]['photoUrl'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageUploadScreen(user)),
        );
      }
    }
  }
}
