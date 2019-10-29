import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:match_hire/job_detail.dart';
import 'package:match_hire/model/project.dart';

List<Project> litems = new List<Project>();

class JobsPage extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseUser user;

  JobsPage(this.user);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite Talent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JobsScreen(
        user: user,
      ),
    );
  }
}

// ignore: must_be_immutable
class JobsScreen extends StatefulWidget {
  FirebaseUser user;

  JobsScreen({this.user});

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    getJobs();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          'Elite Talent',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
            itemCount: litems.length,
            itemBuilder: (context, index) {
              return Card(
                  margin: EdgeInsets.all(5),
                  elevation: 3,
                  child: ListTile(
                      onTap: (){
                        handleItemClick(index);
                      },
                      title:
                      Row(
                        children: <Widget>[
                          Text(
                            litems[index].title.substring(0,27)+'..',

                            style: TextStyle(
                                fontSize: 20,
                            ),
                          ),

                        ],
                      ),
                      trailing: IconButton(icon:Icon( Icons.favorite_border,color: Colors.blue,),onPressed: (){},),

                      subtitle: Column(
                        children: <Widget>[
                          Align(
                            child: Text(
                              'Budget',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Align(
                            child: Text(
                              litems[index].budget,
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Align(
                            child: Text(
                              'Time',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                            alignment: Alignment.topLeft,
                          ),
                          Align(
                            child: Text(litems[index].time, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                            alignment: Alignment.topLeft,
                          ),
                          Align(
                            child: Text(
                              litems[index].description.substring(0,27)+'..',
                              style: TextStyle(fontSize: 20),
                            ),
                            alignment: Alignment.topLeft,
                          ),
                        ],
                      )),
              );
            }),
      ),
    );
  }

  void handleItemClick(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobsDetailPage(litems[index])),
    );
  }
  
  
  void getJobs(){


      for(var i=0;i<5;i++){
        Project job = new Project("Lorem Ipsum is simply dummy this is simple text", "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum", "20","2:00:00",'null','');
        litems.add(job);
      }
  }
}
