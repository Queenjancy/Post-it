import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/homepage/ShowDataPage.dart';
import 'package:time_machine/time_machine.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SubmitForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      home: new FormPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => new _FormPageState();
}


class _FormPageState extends State<FormPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _newname, _newurl, _newemail, _userid;

  static DatabaseReference ref = FirebaseDatabase.instance.reference();
  String _message;
  var report_status;
  int reportcount = 0;

  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState

    // getname().then(updatename);
    // getdata().then(updateurl);
    // getemail().then(updateemail);
    // getuserid().then(updateuserid);
    get_user_detail();
    get_report_status();
    super.initState();
  }

  Future get_user_detail() async{
    String userid = await storage.read(key: 'user-id');
    String username = await storage.read(key: 'user-name');
    String userimage = await storage.read(key: 'user-image');

    setState(() {
     _newname = username;
     _newurl = userimage;
     _userid = userid;
    });
  }

  Future get_report_status() async{
    report_status = await storage.read(key: 'report-status');
    
    setState(() {
      
    });
  }

  // Future reportstatus() async {
  //   await Future.delayed(Duration(milliseconds: 100), () {
  //     ref.child('user').child('$_userid').child('Report').once().then((DataSnapshot snap) {
  //       var data = snap.value.keys;

  //       for(var key in data){
  //         reportcount++;
  //       }
  //       print('value of data :$data');
  //       setState(() {
  //         if(reportcount>=10){
  //           report_status = 'true';
  //         }
  //       });
  //     });
  //   });
  // }

  void _submit() {
    final form = formKey.currentState;
    print("name :$_newname");
    if (form.validate()) {
      form.save();
      submitmessage();
    }
  }

  void submitmessage() {
    var now = Instant.now();
    var time = now.toString('yyyyMMddHHmmss');
    print('this is post time :$time');

    var date_day = new DateTime.now().day;
    var date_month = new DateTime.now().month;
    var date_year = new DateTime.now().year;

    String date = date_day.toString() +
        ':' +
        date_month.toString() +
        ':' +
        date_year.toString();

    if (_newname.isNotEmpty && _message.isNotEmpty != null && report_status != 'true') {
      ref.child('node-name').child('$time').child('name').set('$_newname');
      ref.child('node-name').child('$time').child('message').set('$_message');
      ref.child('node-name').child('$time').child('msgtime').set('$date');
      ref.child('node-name').child('$time').child('image').set('$_newurl');
      ref.child('node-name').child('$time').child('email').set('$_newemail');
      ref.child('node-name').child('$time').child('userid').set('$_userid');
      ref.child('node-name').child('$time').child('comments').child('no-comments').set('1');
      ref.child('node-name').child('$time').child('likes').child('no-likes').set('1');
      ref.child('user').child('$_userid').child('post').child('$time').child('message').set('$_message');
      ref.child('user').child('$_userid').child('post').child('$time').child('msgtime').set('$date');
      ref.child('user').child('$_userid').child('name').set('$_newname');
      ref.child('user').child('$_userid').child('imageurl').set('$_newurl');
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShowDataPage()));
    } else if (report_status == 'true') {
      _snackbar();
    }
  }

  _snackbar() {
    final snackbar = new SnackBar(
      content: new Text('You have been reported'),
      duration: new Duration(milliseconds: 2000),
      backgroundColor: Colors.red,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceheight = MediaQuery.of(context).size.height;
    final double keyboardheight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        title: Text(
          'NEW POST',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: new Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
        child: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text(
                    '$_newname',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              new Container(
                height: deviceheight - keyboardheight - 200,
                child: TextFormField(
                  cursorColor: Colors.deepPurpleAccent,
                  autocorrect: true,
                  scrollPadding: const EdgeInsets.all(20.0),
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                  autofocus: true,
                  decoration: new InputDecoration(
                      hasFloatingPlaceholder: false, errorMaxLines: 3),
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  validator: (val) =>
                      val.length < 1 ? 'please enter message' : null,
                  onSaved: (val) => _message = val,
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 26.0),
              ),
              new InkWell(
                onTap: () {
                  _submit();
                },
                child: Container(
                  width: 150,
                  height: 50.0,
                  decoration: new BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  child: new Center(
                    child: Text(
                      'POST',
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//end