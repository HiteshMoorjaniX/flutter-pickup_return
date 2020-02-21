import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItemsList.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;

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
    print('Inside pending client\'s pickup list');
    this.fetchPendingPickupItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Client List"),
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
      MaterialPageRoute(builder: (context) => PendingPickupItemsList(pickup_id: pickup_id)),
    );

  }

  Future<String> fetchPendingPickupItems() async {
    await http
        .post(Api_Config.showPendingPickupItems, headers: headerParams)
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
