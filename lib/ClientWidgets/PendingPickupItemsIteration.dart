import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItemsList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:pickup_return/api_config.dart' as Api_Config;

class PendingPickupItemsIteration extends StatefulWidget {
  @override
  _PendingPickupItemsIterationState createState() =>
      _PendingPickupItemsIterationState();
}

class _PendingPickupItemsIterationState
    extends State<PendingPickupItemsIteration> {
  List data;
  bool isLoading = false;

  @override
  void initState() {
    print('Inside pending client\'s pickup list');
    this.fetchPendingPickupItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Pending Pickup Items"),
        ),
        body: _buildProgressIndicator());
    }
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

  showPendingPickupItemsForPickupId(pickup_id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PendingPickupItemsList(pickup_id: pickup_id)),
    );
  }

  Future<String> fetchPendingPickupItems() async {
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
          .get(Api_Config.showPendingPickupItems, headers: headerParams)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("status code :   $statusCode ");
        print(response.body);

        var convertDataToJson = json.decode(response.body);
        data = convertDataToJson['data'];

        setState(() {
          isLoading = false;
        });
      });
    }

    return 'Success';
  }
}
