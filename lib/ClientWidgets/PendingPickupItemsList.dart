import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItems.dart';
import 'package:pickup_return/DeliveryMenWidgets/Challan.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pickup_return/ClientWidgets/PendingPickupItemsChallan.dart'
    as challan;

class PendingPickupItemsList extends StatefulWidget {
  final int pickup_id;

  const PendingPickupItemsList({Key key, this.pickup_id}) : super(key: key);

  @override
  _PendingPickupItemsListState createState() =>
      _PendingPickupItemsListState(pickup_id);
}

class _PendingPickupItemsListState extends State<PendingPickupItemsList> {
  String path;
  var grand_total = 0;
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

    var body = {"pickup_id": '$pickup_id'};

    // var body = {"pickup_id": '11'};

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

    print('data is : ');
    print(data);

    print(data.length);
    for (var i = 0; i < data.length; i++) {
      grand_total = grand_total + data[i]['price'];
    }
    print('Total is : ');
    print(grand_total);
    path = await challan.generatePdf(data, grand_total);
  }

  viewChallan() async {
    String received = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PDFScreen(
                path: path,
                status: 'pickup',
                id: '$pickup_id',
              )),
    );
    if (received == 'pickupclient') {
      Navigator.pop(context);

      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PendingPickupItems()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Pending Pickup Items"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
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
                                style: TextStyle(
                                    fontFamily: "Raleway", letterSpacing: .6),
                              ),
                              subtitle: Text(
                                'Item Quantity : ${data[index]['quantity'].toString()}',
                                style: TextStyle(
                                    fontFamily: "Raleway", letterSpacing: .6),
                              ),
                              // onTap: () => showPendingPickupItemsForPickupId(pickup_id),
                            )

                                // padding: const EdgeInsets.all(20.0),
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ButtonTheme(
              //padding: EdgeInsets.all(5.0),
              minWidth: 200.0,
              height: 45.0,
              child: RaisedButton(
                // padding: const EdgeInsets.all(12.0),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.blue,
                onPressed: () => viewChallan(),
                //onPressed: this.pickSelectedItems(),
                child: new Text("View Challan"),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }
}
