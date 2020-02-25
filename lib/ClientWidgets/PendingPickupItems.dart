import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/ClientOrdersHistory.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItemsList.dart';
import 'package:pickup_return/ClientWidgets/PendingReturnItems.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pickup_return/main.dart';

class PendingPickupItems extends StatefulWidget {
  @override
  _PendingPickupItemsState createState() => _PendingPickupItemsState();
}

class _PendingPickupItemsState extends State<PendingPickupItems> {
  Map<String, String> headerParams = {
    "Accept": 'application/json',
    "Authorization": "Bearer ${globals.authToken}",
  };

  List data;

  @override
  Future<void> initState() {
    // if (globals.authToken == null) {
    //   Navigator.of(context).push(
    //     new MaterialPageRoute(builder: (BuildContext context) => new MyApp()),
    //   );
    // }
    print('Inside pending client\'s pickup list');
    this.fetchPendingPickupItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pending Pickup Items"),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text('Hitesh Moorjani'),
              accountEmail: null,
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new AssetImage('assets/as.png'),
                ),
              ),
            ),
            new ListTile(
                title: new Text('Pending Pickup Items'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new PendingPickupItems()));
                }),
            new ListTile(
                title: new Text('Pending Return Items'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new PendingReturnItems()));
                }),
            new ListTile(
              title: new Text('Request for new Items'),
            ),
            new ListTile(
                title: new Text('Order History'),
                trailing: new Icon(Icons.history),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new ClientOrdersHistory()));
                }),
            new Divider(),
            new ListTile(
              title: new Text('Close'),
              trailing: new Icon(Icons.cancel),
              onTap: () => Navigator.of(context).pop(),
            ),
            new Divider(),
            new ListTile(
                title: new Text('Logout'),
                trailing: new Icon(Icons.account_circle),
                onTap: () {
                  globals.authToken = null;
                  Navigator.of(context).pop();

                  Navigator.of(context).push(
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new MyApp()),
                  );
                }),
          ],
        ),
      ),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          var pickup_id = data[index]['pickup_id'];
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Card(
                    child: new Container(
                        /*child: new Text(data[index]['company_name'], style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(30),
                          fontFamily: "Raleway",
                          letterSpacing: .6
                      ),),*/

                        child: new ListTile(
                      title: Text(
                        data[index]['deliveryboy_name'],
                        style:
                            TextStyle(fontFamily: "Raleway", letterSpacing: .6),
                      ),
                      subtitle: Text(
                        data[index]['pickup_date'],
                        style:
                            TextStyle(fontFamily: "Raleway", letterSpacing: .6),
                      ),
                      onTap: () => showPendingPickupItemsForPickupId(pickup_id),
                    )

                        // padding: const EdgeInsets.all(20.0),
                        ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  showPendingPickupItemsForPickupId(pickup_id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PendingPickupItemsList(pickup_id: pickup_id)),
    );
  }

  Future<String> fetchPendingPickupItems() async {
    await http
        .get(Api_Config.showPendingPickupItems, headers: headerParams)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      print("status code :   $statusCode ");
      print(response.body);

      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['data'];

      setState(() {});
    });

    return 'Success';
  }
}
