import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebaseapp/friend/friend_follower.dart';
import 'package:firebaseapp/friend/friend_following.dart';
import 'package:firebaseapp/friend/message_friend.dart';
import 'package:flutter/material.dart';
import 'package:firebaseapp/user/profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebaseapp/friend/friendpost.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class friendprofile extends StatefulWidget {
  @override
  _friendprofileState createState() => _friendprofileState();
}

class _friendprofileState extends State<friendprofile> {

  final scaffoldKey = new GlobalKey<ScaffoldState>();


  var _friendname;
  var _friendimageurl;
  var _friendid;
  var _userid;
  var _username;
  var _userimage;

  //.................PROFILE VARIABLE...............................

  int postcount = 0;
  int followercount = 0;
  int followingcount = 0;

  var status;
  var _about;
  var _followertext = 'FOLLOW';



  final storage = new FlutterSecureStorage();

  DatabaseReference ref = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    get_user_id();
    friendid();
    super.initState();
  }

  Future friendid() async{
    String friend_id = await storage.read(key: 'friend-id');
    String friend_image = await storage.read(key: 'friend-image');
    String friend_name = await storage.read(key: 'friend-name');

        if(friend_id != null){

      //............................FOLLOWING COUNT OF USER.............................

      ref.child('user').child('$friend_id').child('following').once().then((DataSnapshot snap) async{
        var key = await snap.value.keys;

        for(var following in key){
          followingcount++;
        }
        print('this is keys ${key}');
        setState(() {
          
        });
      });

      //............................POST COUNT OF USER.............................

      ref.child('user').child('$friend_id').child('post').once().then((DataSnapshot snap) async{
        var key = await snap.value.keys;
        for(var post in key){
          postcount ++;
        }
        print('post count :$postcount');
        print('Post key :$key');

        setState(() {
          
        });
      });

      //............................FOLLOWERS COUNT OF USER.............................

      ref.child('user').child('$friend_id').child('follower').once().then((DataSnapshot snap) async{
        var key = await snap.value.keys;
        for(var post in key){
          followercount++;
        }
        print('follower count :$followercount');
        print('Post key :$key');

        setState(() {
          
        });
      });

      //.........................USER STATUS..........................................

      ref.child('user').child('$friend_id').child('status').once().then((DataSnapshot snap) async{
        var statusvalue = await snap.value;
        print('status :$statusvalue');

        setState(() {
          status = statusvalue;
        });
      });

      //.........................USER ABOUT..........................................

      ref.child('user').child('$friend_id').child('about').once().then((DataSnapshot snap) async{
        var about = await snap.value;
        print('about :$about');

        setState(() {
          _about = about;
        });
      });

      ref.child('user').child('$friend_id').child('follower').child('$_userid').once().then((DataSnapshot snap) async{
        var data = await snap.value;
        print('data exst :$data'); 
        if(data != null){
          setState((){
            _followertext = 'FOLLOWING';
          });
        }
      });

    }

    setState(() {
      _friendname = friend_name;
      _friendid = friend_id;
      _friendimageurl = friend_image;
    });
    // print('friend ka id hai :$value');
  }

  TextStyle textstyle = new TextStyle(
    color: Colors.white,
  );

  Future get_user_id() async{
    String userid = await storage.read(key:'user-id');
    String username = await storage.read(key:'user-name');
    String userimage = await storage.read(key:'user-image');
    setState((){
      _userid = userid;
      _username = username;
      _userimage = userimage;
    });
  }

  _snackbar() {
    final snackbar = new SnackBar(
      content: new Text('STARTED FOLLOWING'),
      duration: new Duration(milliseconds: 2000),
      backgroundColor: Colors.green,
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }


  void changepage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color.fromRGBO(64, 75, 96, .9),

      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: new Text("PROFILE",
        
          style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300,

          ),
        ),
      ),

      body:
      
       new Stack(
        children: <Widget>[
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 30.0,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.black38
                      ),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(_friendimageurl),
                          fit: BoxFit.cover,
                        ),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    ),
                  ),
                SizedBox(height: 10.0),
                Text(
                  '$_friendname',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                      color: Colors.blue  
                    ),
                ),
                SizedBox(height: 10.0),

                Text(
                  '$status',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      
                    ),
                ),

                SizedBox(height: 15.0),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>friendfollower()));
                      },
                      child: new Column(
                        children: <Widget>[
                          new Text('$followercount',
                            style: textstyle,
                          ),
                          new Text('Followers',
                            style: textstyle,
                          ),
                        ],
                      ),
                    ),

                    Container(color: Colors.black45, height: 30.0, width: 2,),

                    new GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>friendfollowing()));
                      },
                      child: new Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Text('$followingcount',
                            style: textstyle,
                          ),
                          new Text('Following',
                            style: textstyle,
                          ),
                        ],
                      ),
                    ),

                    Container(color: Colors.black45, height: 30.0, width: 2,),

                    new GestureDetector(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context) => friendpost()));
                      },
                      child: new Column(
                        children: <Widget>[
                          new Text('$postcount',
                            style: textstyle,
                          ),
                          new Text('Post',
                            style: textstyle,
                          )
                        ],
                      ),
                    ),

                  ],
                ),

                SizedBox(height: 15.0),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    new Container(
                      width: MediaQuery.of(context).size.width/2-50,
                      height: 40.0,
                      child: new InkWell(
                        onTap: () {
                          ref.child('user').child('$_userid').child('following').child('$_friendid').child('name').set('$_friendname');
                          ref.child('user').child('$_userid').child('following').child('$_friendid').child('image_url').set('$_friendimageurl');
                          ref.child('user').child('$_friendid').child('follower').child('$_userid').child('name').set('$_username');
                          ref.child('user').child('$_friendid').child('follower').child('$_userid').child('image_url').set('$_userimage');
                          _snackbar();
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.redAccent,
                          shadowColor: Colors.redAccent.withOpacity(0.8),
                          elevation: 7.0,
                          child: Center(
                            child: new Text(
                              '$_followertext',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    new Padding(padding: new EdgeInsets.all(10.0),),

                    new Container(
                      width: MediaQuery.of(context).size.width/2-50,
                      height: 40.0,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>message_friend()));
                        },
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.redAccent,
                          shadowColor: Colors.redAccent.withOpacity(0.8),
                          elevation: 7.0,
                          child: Center(
                            child: new Text(
                              'MESSAGE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),

                SizedBox(height: 15.0),

                new Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('About',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 18.0
                          ),
                        ),

                        new Text('$_about',
                          style: new TextStyle(
                            fontSize: 15.0,
                            color: Colors.white
                          ),
                        ),
                          

                      ],
                    ),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

//end