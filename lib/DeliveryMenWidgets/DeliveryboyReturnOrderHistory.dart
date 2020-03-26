import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/DeliveryMenWidgets/FetchReturnHistory.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeliveryboyReturnOrderHistory extends StatefulWidget {
  @override
  _DeliveryboyReturnOrderHistoryState createState() =>
      _DeliveryboyReturnOrderHistoryState();
}

class _DeliveryboyReturnOrderHistoryState
    extends State<DeliveryboyReturnOrderHistory> {
  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  
  List data;
  List users = new List();

  @override
  void initState() {
    this._getMoreData(page);
    super.initState();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    page = 1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Return Orders History"),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: users.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {
        if (index == users.length) {
          return _buildProgressIndicator();
        } else {
          var return_id = users[index]['return_id'];
          return new ListTile(
            // leading: CircleAvatar(
            //   radius: 30.0,
            //   backgroundImage: new AssetImage('assets/as.png'),
            //   // backgroundImage: NetworkImage(
            //   //   users[index]['picture']['large'],
            //   // ),
            // ),
            title: Text(users[index]['company_name']),
            subtitle: Text((users[index]['return_date'])),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FetchReturnHistory(return_id : return_id)),)
            },
          );
        }
      },
      controller: _sc,
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

  void _getMoreData(int index) async {
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
      var url = '${Api_Config.deliveryboyHistory}?page=' + index.toString();
      print(url);
      var body = {'status': 'return'};
      final response = await http.post(url, headers: headerParams, body: body);
      var convertDataToJson = json.decode(response.body);
      List dataNew = convertDataToJson['data'];
      List tList = new List();
      for (int i = 0; i < dataNew.length; i++) {
        tList.add(dataNew[i]['company_name']);
      }
      print('tList  ');
      print(tList);
      setState(() {
        isLoading = false;
        users.addAll(dataNew);
        page++;
      });
    }
  }
}
