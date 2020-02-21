import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;

class PendingPickupItemsList extends StatefulWidget {
  final int pickup_id;

  const PendingPickupItemsList({Key key, this.pickup_id}) : super(key: key);

  @override
  _PendingPickupItemsListState createState() =>
      _PendingPickupItemsListState(pickup_id);
}

class _PendingPickupItemsListState extends State<PendingPickupItemsList> {
  Map<String, String> headerParams = {
    "Accept": 'application/json',
    "Authorization": "Bearer ${globals.authToken}",
  };
  List data;
  int pickup_id;

  _PendingPickupItemsListState(this.pickup_id);

  @override
  void initState() {
    this.showPendingItems(pickup_id);
    super.initState();
  }

  Future<void> showPendingItems(pickup_id) async {
    print('Pickup id : ');
    print(pickup_id);

    // var body = {"pickup_id": '$pickup_id'};

    var body = {"pickup_id" : '11'};

    await http
        .post(Api_Config.showPendingPickupItemsThroughPickupId,
            body: body, headers: headerParams)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      print("status code :   $statusCode ");
      print(response.body);

      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['data'];

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pending Pickup Items"),
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
                        'Item Name  : ${data[index]['item_name']}',
                        style:
                            TextStyle(fontFamily: "Raleway", letterSpacing: .6),
                      ),
                      subtitle: Text(
                        'Item Quantity : ${data[index]['quantity'].toString()}',
                        style:
                            TextStyle(fontFamily: "Raleway", letterSpacing: .6),
                      ),
                      // onTap: () => showPendingPickupItemsForPickupId(pickup_id),
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
}
