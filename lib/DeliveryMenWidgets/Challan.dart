import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'PickupItemsChallan.dart' as chal;
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;

class PDFScreen extends StatelessWidget {
  final String path;
  final String status;
  final String id;
  final data;
  var cntx;
  PDFScreen({Key key, this.path, this.status, this.id, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    cntx = context;
    // return PDFViewerScaffold(
    //   path: path,

    // );

    return Scaffold(
      // appBar: new AppBar(
      //   title: new Text("Challan"),
      // ),
      body: Stack(
        children: <Widget>[
          PDFViewerScaffold(
            path: path,
            appBar: AppBar(
              title: Text('Challan'),
              actions: <Widget>[
                ButtonTheme(
                  padding: EdgeInsets.all(5.0),
                  minWidth: 70.0,
                  height: 45.0,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(20.0),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    color: Colors.amber,
                    onPressed: () => confirmItems(),
                    child: new Text("Confirm"),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.check),
                //   onPressed: () => {},
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> confirmItems() async {
    var body = {"pickup_id": id};

    Map<String, String> headerParams = {
      "Accept": 'application/json',
      "Authorization": "Bearer ${globals.authToken}",
    };

    if (status == 'pickup') {
      await http
          .post(Api_Config.confirmPendingPickupItems,
              body: body, headers: headerParams)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("status code :   $statusCode ");
        print(response.body);
      });

      Toast.show(
        "Items have been confirmed",
        cntx,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        textColor: Colors.green,
      );

      Navigator.pop(cntx, 'pickupclient');
    } else if (status == 'return') {
      await http
          .post(Api_Config.confirmPendingReturnItems,
              body: {'return_id': id}, headers: headerParams)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("status code :   $statusCode ");
        print(response.body);
      });

      Toast.show(
        "Items have been confirmed",
        cntx,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        textColor: Colors.green,
      );

      Navigator.pop(cntx, 'returnclient');
    } else if (status == 'pickupdeliverymen') {
      await http
          .post(Api_Config.pickedItemsAddApi, headers: headerParams, body: data)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("status code :   $statusCode ");
        print('Response is : $response');
        print(response.body);
      });

      Toast.show(
        "Items have been confirmed",
        cntx,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        textColor: Colors.green,
      );

      Navigator.pop(cntx, 'pickup');
    } else if (status == 'returndeliverymen') {
      await http
          .post(Api_Config.addReturnItems, body: data, headers: headerParams)
          .then((http.Response response) {
        final int statusCode = response.statusCode;

        print("status code :   $statusCode ");
        print(response.body);
      });

      Toast.show(
        "Items have been confirmed",
        cntx,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        textColor: Colors.green,
      );

      Navigator.pop(cntx, 'return');
      // Navigator.of(this.cntx).pop();
    }
  }
}
