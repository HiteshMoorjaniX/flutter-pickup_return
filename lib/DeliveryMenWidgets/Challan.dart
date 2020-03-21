import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItems.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:http/http.dart' as http;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PDFScreen extends StatefulWidget {
  final String path;
  final String status;
  final String id;
  final data;

  PDFScreen({Key key, this.path, this.status, this.id, this.data})
      : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  BuildContext cntx;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    print('path is :  ${widget.path}');
    print('status : ${widget.status}');
    print('id : ${widget.id}');

    cntx = context;
    // return PDFViewerScaffold(
    //   path: path,

    // );
    if (isLoading == true) {
      return new Scaffold(
        appBar: AppBar(
          title: Text('Challan'),
        ),
        body: _buildProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Challan'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 650.0,
                child: PdfViewer(
                  filePath: widget.path,
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
                      onTap: () => confirmItems(),
                      child: Center(
                        child: Text("Confirm",
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
            ],
          ),
        ),
      );
    }

    // return Scaffold(
    //   // appBar: new AppBar(
    //   //   title: new Text("Challan"),
    //   // ),
    //   body: Stack(
    //     children: <Widget>[
    //       PDFViewerScaffold(
    //         path: path,
    //         appBar: AppBar(
    //           title: Text('Challan'),
    //           actions: <Widget>[
    //             ButtonTheme(
    //               padding: EdgeInsets.all(5.0),
    //               minWidth: 70.0,
    //               height: 45.0,
    //               child: RaisedButton(
    //                 padding: const EdgeInsets.all(20.0),
    //                 textColor: Colors.white,
    //                 shape: RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(10.0)),
    //                 color: Colors.amber,
    //                 onPressed: () => confirmItems(),
    //                 child: new Text("Confirm"),
    //               ),
    //             ),
    //             // IconButton(
    //             //   icon: Icon(Icons.check),
    //             //   onPressed: () => {},
    //             // )
    //           ],
    //         ),
    //       ),
    //       Align(
    //         alignment: AlignmentDirectional.bottomStart,

    //         child: new FloatingActionButton(
    //           child: Icon(Icons.camera_alt),
    //           backgroundColor: Colors.green.shade800,
    //           onPressed: () => {},
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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

  Future<void> confirmItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    var body = {"pickup_id": widget.id};

    Map<String, String> headerParams = {
      "Accept": 'application/json',
      "Authorization": "Bearer " "$authToken",
    };

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      if (widget.status == 'pickup') {
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
      } else if (widget.status == 'return') {
        await http
            .post(Api_Config.confirmPendingReturnItems,
                body: {'return_id': widget.id}, headers: headerParams)
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
      } else if (widget.status == 'pickupdeliverymen') {
        await http
            .post(Api_Config.pickedItemsAddApi,
                headers: headerParams, body: widget.data)
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
      } else if (widget.status == 'returndeliverymen') {
        await http
            .post(Api_Config.addReturnItems,
                body: widget.data, headers: headerParams)
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
}
