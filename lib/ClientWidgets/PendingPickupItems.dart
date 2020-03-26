import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/ClientPickupOrdersHistory.dart';
import 'package:pickup_return/ClientWidgets/ClientProfile.dart';
import 'package:pickup_return/ClientWidgets/ClientReturnOrdersHistory.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItemsIteration.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItemsList.dart';
import 'package:pickup_return/ClientWidgets/PendingReturnItems.dart';
import 'package:pickup_return/ClientWidgets/RequestNewItem.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pickup_return/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingPickupItems extends StatefulWidget {
  final int navId;

  const PendingPickupItems({Key key, this.navId}) : super(key: key);

  @override
  _PendingPickupItemsState createState() => _PendingPickupItemsState(navId);
}

class _PendingPickupItemsState extends State<PendingPickupItems> {
  // Map<String, String> headerParams = {
  //   "Accept": 'application/json',
  //   "Authorization": "Bearer ${globals.authToken}",
  // };
  var navId;
  int _currentIndex = 0;

  _PendingPickupItemsState(this.navId) {
    _currentIndex = this.navId;
  }

  final List<Widget> _children = [
    PendingPickupItemsIteration(),
    PendingReturnItems(),
    ClientPickupOrdersHistory(),
    ClientReturnOrdersHistory(),
    RequestNewItem(),
    ClientProfile(),
  ];

  List data;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text("Pending Pickup Items"),
      // ),
      // drawer: new Drawer(
      //   child: new ListView(
      //     children: <Widget>[
      //       new UserAccountsDrawerHeader(
      //         accountName: new Text('Hitesh Moorjani'),
      //         accountEmail: null,
      //         currentAccountPicture: new GestureDetector(
      //           child: new CircleAvatar(
      //             backgroundImage: new AssetImage('assets/as.png'),
      //           ),
      //         ),
      //       ),
      //       new ListTile(
      //           title: new Text('Pending Pickup Items'),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).push(new MaterialPageRoute(
      //                 builder: (BuildContext context) =>
      //                     new PendingPickupItems()));
      //           }),
      //       new ListTile(
      //           title: new Text('Pending Return Items'),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).push(new MaterialPageRoute(
      //                 builder: (BuildContext context) =>
      //                     new PendingReturnItems()));
      //           }),
      //       // new ListTile(
      //       //   title: new Text('Request for new Items'),
      //       // ),
      //       new ListTile(
      //           title: new Text('Pickup Orders History'),
      //           trailing: new Icon(Icons.history),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).push(new MaterialPageRoute(
      //                 builder: (BuildContext context) =>
      //                     new ClientPickupOrdersHistory()));
      //           }),
      //           new ListTile(
      //           title: new Text('Return Orders History'),
      //           trailing: new Icon(Icons.history),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).push(new MaterialPageRoute(
      //                 builder: (BuildContext context) =>
      //                     new ClientReturnOrdersHistory()));
      //           }),
      //       new Divider(),
      //       new ListTile(
      //         title: new Text('Logout'),
      //         trailing: new Icon(Icons.cancel),
      //         onTap: () => this.profile(),
      //       ),
      //       new Divider(),
      //       // new ListTile(
      //       //     title: new Text('Logout'),
      //       //     trailing: new Icon(Icons.account_circle),
      //       //     onTap: () {
      //       //       globals.authToken = null;
      //       //       Navigator.of(context).pop();

      //       //       Navigator.of(context).push(
      //       //         new MaterialPageRoute(
      //       //             builder: (BuildContext context) => new MyApp()),
      //       //       );
      //       //     }),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          Icon(
            Icons.verified_user,
            size: 20,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.add,
            size: 20,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.list,
            size: 20,
            color: Colors.blueAccent,
          ),
          // Icon(Icons.favorite,size: 20,color: Colors.blueAccent,),
          Icon(
            Icons.history,
            size: 20,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.add,
            size: 20,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.account_circle,
            size: 20,
            color: Colors.blueAccent,
          ),
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.easeInCirc,
        index: _currentIndex,
        onTap: (index) {
          print('index is : $index');
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _children[_currentIndex],
      // body: new ListView.builder(
      //   itemCount: data == null ? 0 : data.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     var pickup_id = data[index]['pickup_id'];
      //     return new Container(
      //       child: new Center(
      //         child: new Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: <Widget>[
      //             new Card(
      //               child: new Container(
      //                   /*child: new Text(data[index]['company_name'], style: TextStyle(
      //                     fontSize: ScreenUtil.getInstance().setSp(30),
      //                     fontFamily: "Raleway",
      //                     letterSpacing: .6
      //                 ),),*/

      //                   child: new ListTile(
      //                 title: Text(
      //                   data[index]['deliveryboy_name'],
      //                   style:
      //                       TextStyle(fontFamily: "Raleway", letterSpacing: .6),
      //                 ),
      //                 subtitle: Text(
      //                   data[index]['pickup_date'],
      //                   style:
      //                       TextStyle(fontFamily: "Raleway", letterSpacing: .6),
      //                 ),
      //                 onTap: () => showPendingPickupItemsForPickupId(pickup_id),
      //               )

      //                   // padding: const EdgeInsets.all(20.0),
      //                   ),
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
