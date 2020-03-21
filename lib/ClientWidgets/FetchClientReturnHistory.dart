import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FetchClientReturnHistory extends StatefulWidget {
  final int return_id;

  const FetchClientReturnHistory({Key key, this.return_id}) : super(key: key);
  @override
  _FetchClientReturnHistoryState createState() => _FetchClientReturnHistoryState(return_id);
}

class _FetchClientReturnHistoryState extends State<FetchClientReturnHistory> {

  static int page = 1;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;

  List data;
  List users = new List();

  int return_id;
  _FetchClientReturnHistoryState(this.return_id);

  @override
  void initState() {
    this._getMoreData(page, return_id);
    super.initState();

    _sc.addListener(() {
      if (_sc.position.pixels == _sc.position.maxScrollExtent) {
        _getMoreData(page, return_id);
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
          return new ListTile(
            title: Text('item name : ${users[index]['item_name']}, quantity: ${users[index]['quantity']} '),
            subtitle: Text(('Price : ${users[index]['price']} ')),
            // onTap: () => {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => FetchPickupHistory()),)
            // },
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

  void _getMoreData(int index,return_id) async {
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
      var url = '${Api_Config.returnHistory}?page=' + index.toString();
      print(url);
      var body = {'return_id': '${return_id}'};
      final response = await http.post(url, headers: headerParams, body: body);
      var convertDataToJson = json.decode(response.body);
      List dataNew = convertDataToJson['data'];
      List tList = new List();
      for (int i = 0; i < dataNew.length; i++) {
        tList.add(dataNew[i]['item_name']);
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