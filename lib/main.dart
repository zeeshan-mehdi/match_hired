import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:match_hire/chat.dart';
import 'package:match_hire/home.dart';
import 'package:match_hire/model/Job.dart';
import 'package:match_hire/model/User.dart';

import 'login.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

FirebaseUser user;
var ctx;

double width = 400;
double height = 500;

final Widget placeholder = Container(color: Colors.grey);

final List child = map<Widget>(
  LoginPage.users,
  (index, i) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Column(children: <Widget>[
            Stack(children: <Widget>[
              Container(
                  width: width,
                  height: height - 170,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(LoginPage.users[index].photoUrl),
                          fit: BoxFit.cover))),
              Positioned(
                bottom: 0.0,
                left: 3.0,
                child: Text(
                  LoginPage.users[index].name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ]),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Icon(
                        Icons.work,
                        color: Colors.redAccent,
                        size: 40.0,
                      ),
                      onPressed: () {
                        hireTheGuy(LoginPage.users[index]);
                      },
                    ),
                    FlatButton(
                      child: Icon(
                        Icons.chat,
                        color: Colors.redAccent,
                        size: 40.0,
                      ),
                      onPressed: () {
                        Navigator.push(
                          ctx,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                  peerId: LoginPage.users[index].id, peerAvatar: LoginPage.users[index].photoUrl)),
                        );
                      },
                    ),
                  ],
                )),
          ])),
    );
  },
).toList();

void hireTheGuy(User user) async{
  var userId = await FirebaseAuth.instance.currentUser();
  final hiring = Firestore.instance.collection("hired").document(userId.uid).collection("hired");

  Job job = new Job(user.id, true);

  hiring.add(job.toJson());


  Fluttertoast.showToast(msg: 'You have Hired this User');
}

//void openChat(index,context) {
//  Navigator.push(
//      context,
//      MaterialPageRoute(
//          builder: (context) => Chat(
//                peerId: document.documentID,
//                peerAvatar: document['photoUrl'],
//              )));
//}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

void main() async {
  var user = await FirebaseAuth.instance.currentUser();
  if (user == null) {
    runApp(LoginScreen());
  } else {
    await fetchUsers(user.uid);
    //filterUsers(user.uid);
    runApp(HomePage(user));
  }

}

class MyApp extends StatelessWidget {
  FirebaseUser firebaseUser;

  MyApp(this.firebaseUser);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Hired',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Look For Match'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.firebaseUser}) : super(key: key);
  final String title;
  final FirebaseUser firebaseUser;

  @override
  _MyHomePageState createState()=>_MyHomePageState();

}



Future<void> fetchUsers(String uid) async {
  final QuerySnapshot result =
  await Firestore.instance.collection('users').getDocuments();
  final List<DocumentSnapshot> documents = result.documents;
  if (documents.length != 0) {
    documents.forEach((snapshot) {

      User user = new User(snapshot['id'], snapshot['nickname'],
          snapshot['photoUrl'], snapshot['country']);

      if(uid != user.id)
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

class _MyHomePageState extends State<MyHomePage> {
  int _current = 0;

  @override
  void initState() {
    // TODO: implement initState
//    fetchUsers();
    user = widget.firebaseUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;


    if(LoginPage.users.length==0){
      return null;
    }


     //print('length ............................................'+length.toString());

    //Fluttertoast.showToast(msg: 'Length' + LoginPage.users.length.toString());

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Stack(children: [
          CarouselSlider(
            items: child,
            autoPlay: false,
            height: MediaQuery.of(context).size.height,
            aspectRatio: 2.0,
            viewportFraction: 1.0,
            enlargeCenterPage: true,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
        ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
