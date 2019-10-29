import 'package:flutter/material.dart';
import 'package:match_hire/model/project.dart';
import 'package:match_hire/src/utils/settings.dart';
class JobsDetailPage extends StatelessWidget {
  // This widget is the root of your application.
  final Project job;

  JobsDetailPage(this.job);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elite Talent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JobsDetailScreen(
        job: this.job,
      ),
    );
  }
}

// ignore: must_be_immutable
class JobsDetailScreen extends StatefulWidget {
  Project job;

  JobsDetailScreen({this.job});

  @override
  _JobsDetailScreenState createState() => _JobsDetailScreenState();
}

class _JobsDetailScreenState extends State<JobsDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(
              'Job Detail',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: Card(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: HexColor('#f9f9f9'),
                child: Padding(
                  child: Text(
                    widget.job.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  child: Text(
                    widget.job.description,
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.left,
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
              Container(
                color: HexColor('#f9f9f9'),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Budget : ' + widget.job.budget),
                      Text('Time : ' + widget.job.time),
                      Text('Project Poster : ' + widget.job.agency)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 50, top: 50),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: double.infinity),
                  child: FlatButton(
                    color: HexColor('#0dd958'),
                    child: Text('Apply For Job',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: applyForJob,
                  ),
                ),
              ),
            ],
          ),
          elevation: 10,
          margin: EdgeInsets.only(left: 5, right: 5, bottom: 10, top: 10),
        ));
  }

  void handleItemClick(int index) {}

  void applyForJob() {
    
  }
}
