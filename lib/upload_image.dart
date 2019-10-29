import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';
import 'main.dart';

class ImageUploadScreen extends StatelessWidget {
  // This widget is the root of your application.
  FirebaseUser user;

  ImageUploadScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Hired',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ImagePage(user),
    );
  }
}

class ImagePage extends StatefulWidget {
  final String title = "Login";
  FirebaseUser firebaseUser;

  ImagePage(this.firebaseUser);

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  SharedPreferences prefs;

  FirebaseUser currentUser;
  FirebaseUser firebaseUser;
  File _image;
  String _uploadedFileURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Profile Picture'),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      child: TextFormField(
                        controller: _nameController,
                        decoration: new InputDecoration(
                          labelText: "Nick Name",
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
                      child: TextFormField(
                        controller: _countryController,
                        decoration: new InputDecoration(
                          labelText: "Country ",
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
                    Text('Selected Image'),
                    _image != null
                        ? Image.asset(
                            _image.path,
                            height: 200,
                          )
                        : Container(height: 200),
                    _image == null
                        ? Padding(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minWidth: double.infinity),
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)),
                                    color: Theme.of(context).accentColor,
                                    onPressed: chooseFile,
                                    child: const Text(
                                      "Choose Image",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                            padding: EdgeInsets.all(8),
                          )
                        : Container(),
                    _image != null
                        ? Padding(
                            child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    minWidth: double.infinity),
                                child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                        side: BorderSide(color: Colors.red)),
                                    color: Theme.of(context).accentColor,
                                    onPressed: uploadFile,
                                    child: const Text(
                                      "Create Profile",
                                      style: TextStyle(color: Colors.white),
                                    ))),
                            padding: EdgeInsets.all(8),
                          )
                        : Container(),
                  ],
                ),
                Positioned(
                  child: isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(themeColor)),
                          ),
                          color: Colors.white.withOpacity(0.8),
                        )
                      : Container(),
                )
              ],
            )),
      ),
    );
  }

  Future chooseFile() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  clearSelection() {}

  Future uploadFile() async {
    Fluttertoast.showToast(msg: 'please wait we are creating profile');

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('image Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp(firebaseUser)),
        );
        print(fileURL);
        isLoading = true;
        _uploadedFileURL = fileURL;
        createProfile();
      });
    });
  }

  void createProfile() async {
    prefs = await SharedPreferences.getInstance();
    firebaseUser = widget.firebaseUser;

    var country = "US";
    var displayName = "Unknown";
    if (_formKey.currentState.validate()) {
      displayName = _nameController.text;
      country = _countryController.text;
    } else {
      Fluttertoast.showToast(msg: 'fill all fields ');
      return;
    }

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': displayName,
          'photoUrl': _uploadedFileURL,
          'country': country,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('country', documents[0]['country']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);


      }

      setState(() {
        isLoading = false;
        Fluttertoast.showToast(msg: "Sign in success");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp(currentUser)),
        );
      });
    }
  }
}
