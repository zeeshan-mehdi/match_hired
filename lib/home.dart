import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:match_hire/add_job.dart';
import 'package:match_hire/hired.dart';
import 'package:match_hire/main.dart' as prefix0;
import 'package:match_hire/model/Job.dart';
import 'package:match_hire/projects.dart';


class HomePage extends StatelessWidget {
  final FirebaseUser user;
  HomePage(this.user);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Hired',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(user: this.user,),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final FirebaseUser user;
  static List<Job> people = new List<Job>();
  MyHomePage({Key key,this.user}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _current = 0;



  @override
  void initState() {
    // TODO: implement initState
//    fetchUsers();
      fetchHiredPeople();
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
        title: Text('Match Hired'),
      ),
      body: Container(
        child: Padding(
          child:Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.purpleAccent,
                      child: Center(
                          child: Text(
                            'Hire People',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    onTap: ()async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => prefix0.MyApp(widget.user),
                          ));
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.green,
                      child: Center(
                          child: Text(
                            'Post a project',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddJobPage(),
                          ));
                    },
                  ),
                ],
              ),
              Padding(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.yellow,
                      child: Center(
                          child: Text(
                            'Hired People',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    onTap: ()async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HiredPage(),
                          ));
                    },
                  ),
                  InkWell(
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.blue,
                      child: Center(
                          child: Text(
                            'My Projects',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>ProjectsPage(),
                          ));
                    },
                  ),
                ],
              ),
              padding: EdgeInsets.only(top: 10),
              ),
            ],
          ),
          padding: EdgeInsets.only(top: 10),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  fetchHiredPeople()async{
    final hiring = await Firestore.instance.collection("hired").document(widget.user.uid).collection('hired').getDocuments();

    MyHomePage.people = new List<Job>();
    hiring.documents.forEach((doc){
      Job job = Job(doc['id'],doc['hired']);
      MyHomePage.people.add(job);
    });

    //print(MyHomePage.people);

  }

}
