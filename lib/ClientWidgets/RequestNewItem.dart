import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItems.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class RequestNewItem extends StatefulWidget {
  @override
  _RequestNewItemState createState() => _RequestNewItemState();
}

class _RequestNewItemState extends State<RequestNewItem> {
  final itemName = TextEditingController();
  final itemDetails = TextEditingController();
  final itemQuanity = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    if (isLoading == true) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Request new item'),
        ),
        body: _buildProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Request new item'),
      ),
      body: Container(
        width: double.infinity,
        height: ScreenUtil.getInstance().setHeight(800),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Request New Item",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: "Poppins-Bold",
                      letterSpacing: .6)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Item Name",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: itemName,
                decoration: InputDecoration(
                    hintText: "Item Name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Item Description",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: itemDetails,
                // readOnly: true,
                // obscureText: true,
                decoration: InputDecoration(
                    hintText: "Item Description",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text("Item Quantity",
                  style: TextStyle(
                      fontFamily: "Poppins-Medium",
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextField(
                controller: itemQuanity,
                keyboardType: TextInputType.phone,
                // obscureText: true,
                decoration: InputDecoration(
                    hintText: "Item Quantity",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                          onTap: () => requestNewItem(),
                          child: Center(
                            child: Text("Submit",
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
              )
            ],
          ),
        ),
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

  Future<void> requestNewItem() async {
    // if(itemName.text)
    if (itemName.text.isEmpty ||
        itemDetails.text.isEmpty ||
        itemQuanity.text.isEmpty) {
      return Toast.show(
        "Please provide mandotary details",
        context,
        duration: 4,
        gravity: Toast.CENTER,
        textColor: Colors.red,
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var authToken = prefs.getString('authToken');
      Map<String, String> headerParams = {
        "Accept": 'application/json',
        "Authorization": "Bearer " "$authToken",
      };

      var body = {
        "item_name": itemName.text,
        "details": itemDetails.text,
        "quantity": itemQuanity.text,
      };

      // print(body);

      if (!isLoading) {
        setState(() {
          isLoading = true;
        });

        await http
            .post(Api_Config.requestNewItem, headers: headerParams, body: body)
            .then((http.Response response) {
          final int statusCode = response.statusCode;

          print("status code :   $statusCode ");
          print(response.body);
          setState(() {
            isLoading = false;
          });
        });
      }

      Toast.show(
        "Item request submitted successfully.",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.CENTER,
        textColor: Colors.green,
      );

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PendingPickupItems(
                  navId: 4,
                )),
      );
    }
  }
}
