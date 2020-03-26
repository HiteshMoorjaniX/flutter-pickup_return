import 'package:flutter/material.dart';
import 'package:pickup_return/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 250.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // new Icon(
                              //   Icons.arrow_back_ios,
                              //   color: Colors.black,
                              //   size: 22.0,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: new Text('PROFILE',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        fontFamily: 'sans-serif-light',
                                        color: Colors.black)),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 190.0, top: 0.0),
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.blueAccent,
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.remove('usertype');
                                      prefs.remove('authToken');
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext cntx) =>
                                                  MyApp()));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                        Color(0xFF17ead9),
                                        Color(0xFF6078ea)
                                      ])),
                                      child: Text('Logout'),
                                    ),
                                  )
                                  // Container(
                                  //   width: ScreenUtil.getInstance().setWidth(330),
                                  //   height: ScreenUtil.getInstance().setHeight(100),
                                  //   decoration: BoxDecoration(
                                  //       gradient: LinearGradient(colors: [
                                  //         Color(0xFF17ead9),
                                  //         Color(0xFF6078ea)
                                  //       ]),
                                  //       borderRadius: BorderRadius.circular(6.0),
                                  //       boxShadow: [
                                  //         BoxShadow(
                                  //             color:
                                  //                 Color(0xFF6078ea).withOpacity(.3),
                                  //             offset: Offset(0.0, 8.0),
                                  //             blurRadius: 8.0)
                                  //       ]),
                                  //   child: Material(
                                  //     color: Colors.transparent,
                                  //     child: InkWell(
                                  //       onTap: () {},
                                  //       child: Center(
                                  //         child: Text("SIGNIN",
                                  //             style: TextStyle(
                                  //                 color: Colors.white,
                                  //                 fontFamily: "Poppins-Bold",
                                  //                 fontSize: 18,
                                  //                 letterSpacing: 1.0)),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )

                                  ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child:
                            new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: new AssetImage('assets/as.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Change Password',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Current Password',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: TextField(
                                    controller: currentPassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Current Password",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0)),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'New Password',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: TextField(
                                    controller: newPassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "New Password",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0)),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Confirm New Password',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: TextField(
                                    controller: confirmNewPassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        hintText: "Confirm New Password",
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0)),
                                  ),
                                ),
                              ],
                            )),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () => save(),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Future<void> save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    Map<String, String> headerParams = {
      "Accept": 'application/json',
      "Authorization": "Bearer " "$authToken",
    };
    var body = {
      "current_password": currentPassword.text,
      'password': newPassword.text,
      'password_confirmation': confirmNewPassword.text
    };

    await http
        .post(Api_Config.changePassword, headers: headerParams, body: body)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      print("status code :   $statusCode ");
      print(response.body);

      if (statusCode == 200) {
        setState(() {
          _status = true;
          FocusScope.of(context).requestFocus(new FocusNode());
        });

        Toast.show(
          "Password changed successfully",
          context,
          duration: 4,
          gravity: Toast.CENTER,
          textColor: Colors.green,
        );
        
      } else {
        Toast.show(
          'Please enter valid details',
          context,
          duration: 4,
          gravity: Toast.CENTER,
          textColor: Colors.red,
        );
        
      }
    });
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.blueAccent,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
