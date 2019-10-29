
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:match_hire/home.dart';
import 'package:match_hire/model/User.dart';
import 'package:match_hire/model/project.dart';

import 'login.dart';

class ProjectsPage extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Hired',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyProjectsPage(),
    );
  }
}

class MyProjectsPage extends StatefulWidget {
  MyProjectsPage({Key key}) : super(key: key);

  @override
  _MyProjectsPageState createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {

  List<Project> projects= new List<Project>();
  @override
  void initState() {
    // TODO: implement initState
//    fetchUsers();
    super.initState();
     grabProjects();
  }

  @override
  Widget build(BuildContext context) {
    //print('length ............................................'+length.toString());

    //Fluttertoast.showToast(msg: 'Length' + LoginPage.users.length.toString());

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Projects'),
      ),
      body:ListView.builder(
          itemCount:projects.length,
          itemBuilder: (context,index){
        return ListTile(
          title: Text(projects[index].title),
          trailing: Icon(Icons.assessment),
          subtitle: Text(projects[index].description),
        );
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }

  void grabProjects() async {

    var user = await FirebaseAuth.instance.currentUser();

    final hiring = await Firestore.instance.collection("projects").document(user.uid).collection('projects').getDocuments();

    projects = new List<Project>();
    hiring.documents.forEach((doc){
      Project job = Project(doc['title'],doc['description'],doc['budget'],doc['time'],doc['fileUrl'],doc['agency']);
      setState(() {
        projects.add(job);
      });

    });

  }
}
