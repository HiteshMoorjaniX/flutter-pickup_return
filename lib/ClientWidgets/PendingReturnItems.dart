import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/PendingReturnItemsList.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PendingReturnItems extends StatefulWidget {
  @override
  _PendingReturnItemsState createState() => _PendingReturnItemsState();
}

class _PendingReturnItemsState extends State<PendingReturnItems> {
  // Map<String, String> headerParams = {
  //   "Accept": 'application/json',
  //   "Authorization": "Bearer ${globals.authToken}",
  // };

  List data;
  bool isLoading = false;

  @override
  void initState() {
    this.fetchPendingReturnItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return new Scaffold(
          appBar: new AppBar(
            title: Text('Pending Return Items'),
          ),
          body: _buildProgressIndicator());
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Pending Return Items"),
      ),
      body: new ListView.builder(
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
                        data[index]['deliveryboy_name'],
                        style:
                            TextStyle(fontFamily: "Raleway", letterSpacing: .6),
                      ),
                      subtitle: Text(
                        data[index]['return_date'],
                        style:
                            TextStyle(fontFamily: "Raleway", letterSpacing: .6),
                      ),
                      onTap: () => showPendingReturnItemsForReturnId(return_id),
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

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  showPendingReturnItemsForReturnId(return_id) {
    print('ReturnId ::');
    print(return_id);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PendingReturnItemsList(return_id: return_id)),
    );
  }

  Future<String> fetchPendingReturnItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    Map<String, String> headerParams = {
      "Accept": 'application/json',
      "Authorization": "Bearer " "$authToken",
    };

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      await http
          .get(Api_Config.showPendingReturnItems, headers: headerParams)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("status code :   $statusCode ");
        print(response.body);

        var convertDataToJson = json.decode(response.body);
        data = convertDataToJson['data'];

        print(data);

        setState(() {
          isLoading = false;
        });
      });
    }

    return 'Success';
  }
}
