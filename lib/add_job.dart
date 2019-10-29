import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:match_hire/hired.dart';
import 'package:match_hire/main.dart' as prefix0;
import 'package:match_hire/model/Job.dart';
import 'package:match_hire/model/project.dart';

class AddJobPage extends StatelessWidget {

  AddJobPage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Hired',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AddJobScreen(
      ),
    );
  }
}

class AddJobScreen extends StatefulWidget {

  AddJobScreen({Key key}) : super(key: key);

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _budgetController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
//    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('length ............................................'+length.toString());

    //Fluttertoast.showToast(msg: 'Length' + LoginPage.users.length.toString());

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Project'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(children: <Widget>[
          Padding(
            child: TextFormField(
              controller: _titleController,
              decoration: new InputDecoration(
                labelText: "Project Title",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "title cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.text,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            padding: EdgeInsets.all(8),
          ),
          Padding(
            child: TextFormField(
              maxLines: null,
              controller: _descController,
              decoration: new InputDecoration(
                labelText: "Project Detail",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Project Detail cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.text,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            padding: EdgeInsets.all(8),
          ),
          Padding(
            child: TextFormField(
              controller: _budgetController,
              decoration: new InputDecoration(
                labelText: "Budget in \$ like 20",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Budget cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.text,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            padding: EdgeInsets.all(8),
          ),

          Padding(
            child: TextFormField(
              controller: _timeController,
              decoration: new InputDecoration(
                labelText: "Time for example 2:05:40",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Time cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.text,
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
                    onPressed: createJob,
                    child: const Text(
                      "Add Project",
                      style: TextStyle(color: Colors.white),
                    ))),
            padding: EdgeInsets.all(8),
          )
        ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void createJob() async{

    var userId = await FirebaseAuth.instance.currentUser();
    final hiring = Firestore.instance.collection("projects").document(userId.uid).collection("projects");

    Project job = new Project(_titleController.text, _descController.text, _budgetController.text, _timeController.text, 'null',userId.uid);

    hiring.add(job.toJson());


    Fluttertoast.showToast(msg: 'Project Added');

    Navigator.of(context).pop();
  }
}
