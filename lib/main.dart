import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pickup_return/ClientWidgets/ClientRegistration.dart';
import 'package:pickup_return/TermsConditions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'ClientWidgets/PendingPickupItems.dart';
import 'DeliveryMenWidgets/ClientList.dart';
import 'login.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'api_config.dart' as Api_Config;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var usertype = prefs.getString('usertype');
  print(usertype);
  if (usertype == 'deliveryboy') {
    runApp(MaterialApp(home: ClientList(), debugShowCheckedModeBanner: false));
  } else if (usertype == 'client') {
    runApp(MaterialApp(
        home: PendingPickupItems(navId: 0,), debugShowCheckedModeBanner: false));
  } else {
    runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
  }
}

// void main() => runApp(MaterialApp(
//       home: MyApp(),
//       debugShowCheckedModeBanner: false,
//     ));

final loginText = TextEditingController();
final passwordText = TextEditingController();
var token;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSelected = false;
  Future<Login> login;
  bool agree = false;
  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Image.asset("assets/logo-web-transparent.png"),
                  )),
              Expanded(
                child: Container(),
              ),
              Image.asset("assets/image_02.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil.getInstance().setHeight(180),
                      ),
                      // Image.asset(
                      //   "assets/logo-web-transparent.png",
                      //   width: ScreenUtil.getInstance().setWidth(110),
                      //   height: ScreenUtil.getInstance().setHeight(110),
                      // ),
                      Text("",
                          style: TextStyle(
                              fontFamily: "Poppins-Bold",
                              fontSize: ScreenUtil.getInstance().setSp(46),
                              letterSpacing: .6,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(230),
                  ),
                  //FormCard(),

                  // taking username and password widget.
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(500),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Login",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(45),
                                  fontFamily: "Poppins-Bold",
                                  letterSpacing: .6)),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("Username",
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: loginText,
                            decoration: InputDecoration(
                                hintText: "username",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("PassWord",
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontSize:
                                      ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            controller: passwordText,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0)),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: "Poppins-Medium",
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(28)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: agree,
                        onChanged: (bool value) {
                          setState(() {
                            print(value);
                            agree = value;
                          });
                        },
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TermsConditions()),
                        ),
                        child: Text("I Agree with term and conditions.",
                            style: TextStyle(
                                color: Color(0xFF5d74e3),
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  ),
                  // SizedBox(height: ScreenUtil.getInstance().setHeight(100)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 12.0,
                          ),
                          GestureDetector(
                            onTap: _radio,
                            child: radioButton(_isSelected),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text("Remember me",
                              style: TextStyle(
                                  fontSize: 12, fontFamily: "Poppins-Medium"))
                        ],
                      ),
                      InkWell(
                        child: Container(
                          width: ScreenUtil.getInstance().setWidth(330),
                          height: ScreenUtil.getInstance().setHeight(100),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFF17ead9),
                                Color(0xFF6078ea)
                              ]),
                              borderRadius: BorderRadius.circular(6.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(.3),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                Login lg = new Login(
                                    username: loginText.text,
                                    password: passwordText.text);

                                print("Helloo");
                                var status = await fetchLogin(body: lg.toMap());
                                if (status == 'deliveryboy') {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('usertype', 'deliveryboy');
                                  prefs.setString(
                                      'authToken', globals.authToken);
                                  // prefs.setBool("isLoggedIn", true);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => PickupItem()),);
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => ClientList(), settings: RouteSettings(arguments: token)),);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ClientList()),
                                  );
                                } else if (status == 'client') {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  // prefs.setBool("isLoggedIn", true);
                                  prefs.setString('usertype', 'client');
                                  prefs.setString(
                                      'authToken', globals.authToken);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PendingPickupItems(navId: 0,)),
                                  );
                                } else {
                                  Toast.show(
                                    "Invalid Username/Password",
                                    context,
                                    duration: 4,
                                    gravity: Toast.CENTER,
                                    textColor: Colors.red,
                                  );
                                }
                              },
                              child: Center(
                                child: Text("SIGNIN",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Poppins-Bold",
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("Social Login",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Poppins-Medium")),
                      horizontalLine()
                    ],
                  ),*/
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(10),
                  ),
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcon(
                        colors: [
                          Color(0xFF102397),
                          Color(0xFF187adf),
                          Color(0xFF00eaf8),
                        ],
                        iconData: CustomIcons.facebook,
                        onPressed: () {},
                      ),
                      SocialIcon(
                        colors: [
                          Color(0xFFff4f38),
                          Color(0xFFff355d),
                        ],
                        iconData: CustomIcons.googlePlus,
                        onPressed: () {},
                      ),
                      SocialIcon(
                        colors: [
                          Color(0xFF17ead9),
                          Color(0xFF6078ea),
                        ],
                        iconData: CustomIcons.twitter,
                        onPressed: () {},
                      ),
                      SocialIcon(
                        colors: [
                          Color(0xFF00c6fb),
                          Color(0xFF005bea),
                        ],
                        iconData: CustomIcons.linkedin,
                        onPressed: () {},
                      )
                    ],
                  ),*/
                  // SizedBox(
                  //   height: ScreenUtil.getInstance().setHeight(30),
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: <Widget>[
                  //     Text(
                  //       "New User? ",
                  //       style: TextStyle(fontFamily: "Poppins-Medium"),
                  //     ),
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientRegistration()),
                    ),
                    child: Text("SignUp (Only for clients).",
                        style: TextStyle(
                            color: Color(0xFF5d74e3),
                            fontFamily: "Poppins-Bold")),
                  )
                  //   ],
                  // )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<String> fetchLogin({Map body}) async {
  /*  var map = new Map<String, dynamic>();
    map["un"] = un;
    map["pass"] = pass;*/

  return http
      .post(Api_Config.loginApi, body: body
          /*{

          "un" : "" + loginText.text,
          "pass" : "" + passwordText.text
        }
        */

          )
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    print("status code :   $statusCode ");
    //print("Response :" + response.body);
    Map<String, dynamic> user = json.decode(response.body);
    print("Access token :   ");
    print(user['access_token']);
    token = user['access_token'];
    globals.authToken = token;
    print(user['user']['id']);
    print('User type : ');
    print(user['user']['user_type']);

    if (statusCode == 200) {
      return user['user']['user_type'];
    } else {
      return 'error';
    }

    /*Map<String, dynamic> user = json.decode(response.body);
          print(user);
          print(response.body);
          if(user['user']['id'] != null){
            print(user['user']['id']);
            return true;
          }
          else
            {
              return false;
            }*/

    /*if(user['status'] == 'true'){
            print('HOHHO');
            return true;
            //Navigator.push(context, route);
          }
          else {
            print("HAHHA");
            return false;
          }*/
  });
}
