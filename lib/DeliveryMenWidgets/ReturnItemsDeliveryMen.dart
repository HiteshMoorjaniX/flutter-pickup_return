import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/DeliveryMenWidgets/ReturnItemsChallan.dart' as challan;
import 'package:pickup_return/DeliveryMenWidgets/Challan.dart';

class ReturnItems extends StatefulWidget {
  @override
  _ReturnItemsState createState() => _ReturnItemsState();
}

class _ReturnItemsState extends State<ReturnItems> {
  List data;
  List<TextEditingController> _quantityController = new List();

  Map<String, String> headerParams = {
    "Accept": 'application/json',
    "Authorization": "Bearer ${globals.authToken}",
  };

  @override
  void initState() {
    print("Inside Returns Items");
    this.showPickedItemsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text("Return Items List"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data == null ? 0 : data.length,
                itemBuilder: (BuildContext context, int index) {
                  // _quantityController.add(new TextEditingController(text: '0'));

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
                                // subtitle: Text(
                                //   data[index]['description'],
                                //   style: TextStyle(
                                //       fontFamily: "Raleway", letterSpacing: .6),
                                // ),
                                trailing: new Container(
                                  width: 55.0,
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
                                      // new Expanded(
                                      //   child: new IconButton(
                                      //     icon: new Icon(Icons.add),
                                      //     color: Colors.lightBlueAccent,
                                      //     onPressed: () => _addQuantity(index),
                                      //   ),
                                      // )
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
                onPressed: () => returnSelectedItems(),
                //onPressed: this.pickSelectedItems(),
                child: new Text("Return"),
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

  void _removeQuantity(int index) {
    int quantity = int.parse(_quantityController[index].text);

    setState(() {
      if (quantity > 0) {
        quantity--;
      } else {
        quantity = 0;
      }
      _quantityController[index].text = '$quantity';
    });
  }

  Future<String> returnSelectedItems() async {

    var listForChallan = [];

    print(_quantityController.length);

    var jsonArr = [];

    for (int i = 0; i < _quantityController.length; i++) {
      // print(_quantityController[i].text);
      int q = int.parse(_quantityController[i].text);
      if (q > 0) {
        print(data[i]['item_name']);
        print(_quantityController[i].text);
        var item_id = data[i]['items_id'];
        var pickup_id = data[i]['pickup_id'];
        listForChallan.add({'item_id': item_id, 'item_name' : data[i]['item_name'] ,'item_qua': q});
        jsonArr.add({'item_id': item_id, 'pickup_id': pickup_id, 'qty': q});
      }
    }

    print('JsonArray : ');
    print(jsonArr);

    var ls = json.encode(jsonArr);
    print(ls);
    var body = {
      "client_id": '${globals.clientId}',
      "list": ls,
    };
    await http
        .post(Api_Config.addReturnItems, body: body, headers: headerParams)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      print("status code :   $statusCode ");
      print(response.body);
    });


   print('list is :');
    print(listForChallan);
    String path =await challan.generatePdf(listForChallan);


    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PDFScreen(path: path)),
    );



  }

  Future<String> showPickedItemsList() async {
    var body = {
      "client_id": '${globals.clientId}',
    };
    print('f');
    print(body);
    http
        .post(Api_Config.showPickedItems, headers: headerParams, body: body)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      print("status code :   $statusCode ");
      print(response.body);
      Map<String, dynamic> user = json.decode(response.body);
      print(user);

      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['data'];
      print(data.length);
      print(data[0]['item_name']);
      // print(_quantityController.length);

      for (int i = 0; i < data.length; i++) {
        // print(_quantityController[i].text);
        int quantity = int.parse(data[i]['quantity']);
        print('qaua :  $quantity');
        _quantityController.add(new TextEditingController(text: '$quantity'));
        // _quantityController[i].text = '$quantity';
        // print(_quantityController[i]);
        // int q = int.parse(_quantityController[i].text);
        // if (q > 0) {
        //   print(data[i]['item_name']);
        //   print(_quantityController[i].text);
        //   var item_id = data[i]['id'];

        // }
      }

      setState(() {
        // var convertDataToJson = json.decode(response.body);
        // data = convertDataToJson['data'];
      });
    });
  }
}
