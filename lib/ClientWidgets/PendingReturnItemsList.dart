import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItems.dart';
import 'package:pickup_return/ClientWidgets/PendingReturnItems.dart';
import 'package:pickup_return/DeliveryMenWidgets/Challan.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pickup_return/ClientWidgets/PendingReturnItemsChallan.dart'
    as challan;
import 'package:shared_preferences/shared_preferences.dart';

class PendingReturnItemsList extends StatefulWidget {
  final int return_id;

  const PendingReturnItemsList({Key key, this.return_id}) : super(key: key);

  @override
  _PendingReturnItemsListState createState() =>
      _PendingReturnItemsListState(return_id);
}

class _PendingReturnItemsListState extends State<PendingReturnItemsList> {
  String path;

  var grand_total = 0.0;

  // Map<String, String> headerParams = {
  //   "Accept": 'application/json',
  //   "Authorization": "Bearer ${globals.authToken}",
  // };
  List data;
  int return_id;

  _PendingReturnItemsListState(this.return_id);

  @override
  void initState() {
    showPendingItems(return_id);
    super.initState();
  }

  Future<void> showPendingItems(return_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    Map<String, String> headerParams = {
      "Accept": 'application/json',
      "Authorization": "Bearer " "$authToken",
    };
    print('Return id : ');
    print(return_id);

    var body = {
      "return_id": '$return_id',
    };

    await http
        .post(Api_Config.showPendingReturnItemsThroughReturnId,
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
                status: 'return',
                id: '$return_id',
              )),
    );

    if (received == 'returnclient') {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PendingPickupItems(navId: 1,)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Pending Return Items"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: new ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  var return_id = data[index]['return_id'];
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

            InkWell(
              child: Container(
                width: ScreenUtil.getInstance().setWidth(300),
                height: ScreenUtil.getInstance().setHeight(90),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
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
                    onTap: () => viewChallan(),
                    child: Center(
                      child: Text("View Challan",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins-Bold",
                              fontSize: 18,
                              letterSpacing: 1.0)),
                    ),
                  ),
                ),
              ),
            ),

            // ButtonTheme(
            //   //padding: EdgeInsets.all(5.0),
            //   minWidth: 200.0,
            //   height: 45.0,
            //   child: RaisedButton(
            //     // padding: const EdgeInsets.all(12.0),
            //     textColor: Colors.white,
            //     shape: RoundedRectangleBorder(
            //         borderRadius: new BorderRadius.circular(30.0)),
            //     color: Colors.blue,
            //     onPressed: () => viewChallan(),

            //     child: new Text("View Challan"),
            //   ),
            // ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }
}
