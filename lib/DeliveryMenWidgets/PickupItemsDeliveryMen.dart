import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickup_return/globals.dart' as globals;
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class PickupItems extends StatefulWidget {
  @override
  _PickupItemsState createState() => _PickupItemsState();
}

class _PickupItemsState extends State<PickupItems> {
  final String pickupItemsUrl = Api_Config.pickupItemsApi;
  List data;
  var quantity = 0;
  List<TextEditingController> _quantityController = new List();
  Map<dynamic, dynamic> list = new Map<dynamic, dynamic>();
  final String pickedItemsStoreUrl =
      Api_Config.pickedItemsAddApi;

  //LinkedHashMap<String,int> pickupMap = new LinkedHashMap<String,int>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text("Pickup Items List"),
        ),
        /*body: new ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {

              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Card(
                            child: new ListTile(
                          title: Text(
                            data[index]['item_name'],
                            style: TextStyle(
                                fontFamily: "Raleway", letterSpacing: .6),
                          ),
                          subtitle: Text(
                            data[index]['description'],
                            style: TextStyle(
                                fontFamily: "Raleway", letterSpacing: .6),
                          ),
                        )),
                        Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            color: Colors.white,
                            child: ButtonTheme(
                              height: 16.0,
                              minWidth: 10.0,
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4.0),
                                color: Colors.white,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.black,
                                  size: 20.0,
                                ),
                                //onPressed: _removeQuantity
                              ),
                            )),
                        Container(
                            width: 60.0,
                            padding:
                                const EdgeInsets.only(left: 1.0, right: 1.0),
                            child: Center(
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(
                                  hintText: "1",
                                ),
                                keyboardType: TextInputType.number,
                                //controller: _quantityController,
                              ),
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          color: Colors.white,
                          child: ButtonTheme(
                            height: 16.0,
                            minWidth: 10.0,
                            child: RaisedButton(
                              padding: const EdgeInsets.all(4.0),
                              color: Colors.white,
                              child: Icon(Icons.add,
                                  color: Colors.black, size: 20.0),
                              //onPressed: _addQuantity
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

            );
          }),*/
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  _quantityController.add(new TextEditingController(text: '0'));

                  var post = data[index]['id'];
                  return new Container(
                    child: new Center(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Card(
                            child: new Container(
                              child: new ListTile(
                                title: Text(
                                  data[index]['item_name'],
                                  style: TextStyle(
                                      fontFamily: "Raleway", letterSpacing: .6),
                                ),
                                subtitle: Text(
                                  data[index]['description'],
                                  style: TextStyle(
                                      fontFamily: "Raleway", letterSpacing: .6),
                                ),
                                trailing: new Container(
                                  width: 80.0,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      new Expanded(
                                        child: new IconButton(
                                          icon: new Icon(Icons.remove),
                                          color: Colors.lightBlueAccent,
                                          onPressed: () =>
                                              _removeQuantity(index),
                                        ),
                                      ),
                                      new Expanded(
                                        //flex: 3,
                                        child: new TextField(
                                          style: TextStyle(color: Colors.amber),
                                          textAlign: TextAlign.end,
                                          decoration:
                                              new InputDecoration.collapsed(
                                                  hintText: '0'),
                                          controller:
                                              _quantityController[index],
                                          keyboardType: TextInputType.number,
                                          /*inputFormatters: <TextInputFormatter>[
                                   WhitelistingTextInputFormatter.digitsOnly
                                 ],*/
                                        ),
                                      ),
                                      new Expanded(
                                        child: new IconButton(
                                          icon: new Icon(Icons.add),
                                          color: Colors.lightBlueAccent,
                                          onPressed: () => _addQuantity(index),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                onPressed: () => pickSelectedItems(),
                //onPressed: this.pickSelectedItems(),
                child: new Text("Pickup"),
              ),
            )

            /*RaisedButton(
            color: Colors.lightBlueAccent,
            child: Center(
              child: Text("PICKUP",
                  style: TextStyle(

                      color: Colors.white,
                      fontFamily: "Poppins-Bold",
                      fontSize: 18,
                      letterSpacing: 1.0)),
            ),
          )*/
          ],
        )
        /*body: new
        floatingActionButton: FloatingActionButton(
          child: Text("Pickup"),
          onPressed: (){

          },
        ),*/
        );
  }

/*  Future<dynamic>pickSelectedItems() async{
    Map<String,String> abc = new Map<String,String>();
    abc['1'] = '3';
    print("JAHAHAHA");
    var authToken = globals.authToken;
    var bodyData = {
      'client_id' : '1',
      'list' : {
        [
          '3'
        ]
      }
    };

    var response = await http.post(pickedItemsStoreUrl,headers: {"Authorization": "Bearer " "$authToken"},body: bodyData);
    print(response.body);
    *//*var response = await http.get(pickupItemsUrl, headers: {"Authorization": "Bearer " "$authToken"});
    print(response.body);*//*
   // body: {"client_id" : 1});
  }*/



  Future<String> pickSelectedItems() async {
    Map<String, String> headerParams = {
      "Accept": 'application/json',
      "Authorization": "Bearer ${globals.authToken}",
    };

    for (int i = 0; i < _quantityController.length; i++) {
      print(_quantityController[i].text);
      int q = int.parse(_quantityController[i].text);
      if (q > 0) {
        print(data[i]['item_name']);
        print(_quantityController[i].text);
        var item_id = data[i]['id'];

        list['$item_id'] = '$q';
      }
    }

    Map<dynamic,dynamic> abc = new Map<dynamic,dynamic>();
    abc[1] = '3';
    abc[2] = '10';

    var ls = json.encode(list);

    var body = {
      "client_id": '${globals.clientId}',
      "list": ls,
    };



    print('list : $ls');

    var ClientId = globals.clientId;
    print('Client id is : $ClientId');

    var map = new Map<String, String>();
    map['1'] = '3';


    // var response = await http.get(url, headers: {"Authorization" : "Bearer " "$authToken"});
   await http
        .post(pickedItemsStoreUrl,headers: headerParams, body: body

       /*{
              "client_id": 1,
              "list": map,
            }*/

   //         headers: headerParams
   )
        .then((http.Response response) {

      final int statusCode = response.statusCode;

      print("status code :   $statusCode ");
      print('Response is : $response');
      print(response.body);
      Map<String, dynamic> user = json.decode(response.body);
      print(user);
    });
  }

  void _addQuantity(int index) {
    int quantity = int.parse(_quantityController[index].text);
    // quantity = _quantityController[index].text as int;
    //quantity = _quantityController[index].value as int;
    // quantity = _quantityController[index] as int;

    setState(() {
      quantity++;
      _quantityController[index].text = '$quantity';
    });
    // _quantityController[index].dispose();
  }

  void _removeQuantity(int index) {
    int quantity = int.parse(_quantityController[index].text);
    //var quantity = _quantityController[index];
    //quantity = int.parse(_quantityController[index].text);

    setState(() {
      if (quantity > 0) {
        quantity--;
      } else {
        quantity = 0;
      }
      _quantityController[index].text = '$quantity';
    });
  }

  @override
  void initState() {
    print("Inside Pickup Items");
    this.fetchPickupItems();
    super.initState();
  }

  Future<String> fetchPickupItems() async {
    var authToken = globals.authToken;
    var response = await http.get(pickupItemsUrl,
        headers: {"Authorization": "Bearer " "$authToken"});

    print(response.body);

    var convertDataToJson = json.decode(response.body);
    data = convertDataToJson['data'];
    print(data[0]['item_name']);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['data'];
    });
    return "Success";
  }
}
