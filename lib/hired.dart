
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:match_hire/home.dart';
import 'package:match_hire/model/User.dart';

import 'login.dart';

class HiredPage extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Match Hired',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHiredPage(),
    );
  }
}

class MyHiredPage extends StatefulWidget {
  MyHiredPage({Key key}) : super(key: key);

  @override
  _MyHiredPageState createState() => _MyHiredPageState();
}

class _MyHiredPageState extends State<MyHiredPage> {

  List<User> users = new List<User>();
  @override
  void initState() {
    // TODO: implement initState
//    fetchUsers();
    super.initState();
     filterPeople();
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
      body:ListView.builder(
          itemCount:users.length,
          itemBuilder: (context,index){
        return ListTile(
          title: Text(users[index].name),

          leading: Image.network(users[index].photoUrl),
        );
      }), // This trailing comma makes auto-formatting nicer for build methods.
    );

  }

  void filterPeople() {
    for(var i=0;i<MyHomePage.people.length;i++){
      var id = MyHomePage.people[i].id;
      LoginPage.users.forEach((user){
        if(id == user.id){
          setState(() {
            print('inside');
            users.add(user);
          });

        }
      });
    }

  }
}
