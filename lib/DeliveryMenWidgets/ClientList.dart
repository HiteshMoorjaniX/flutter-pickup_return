import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pickup_return/DeliveryMenWidgets/ClientListIteration.dart';
import 'package:pickup_return/DeliveryMenWidgets/DeliveryboyPickupOrderHistory.dart';
import 'package:pickup_return/DeliveryMenWidgets/DeliveryboyProfile.dart';
import 'package:pickup_return/DeliveryMenWidgets/DeliveryboyReturnOrderHistory.dart';
import 'package:pickup_return/DeliveryMenWidgets/FancyPopup.dart';

// import 'package:flutter_app/Widgets/FancyPopup.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

// import 'PickupItemsDeliveryMen.dart';
// import 'ReturnItemsDeliveryMen.dart';
// import 'TemplateButton.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class ClientList extends StatefulWidget {
  @override
  _ClientListState createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    ClientListIteration(),
    DeliveryboyPickupOrderHistory(),
    DeliveryboyReturnOrderHistory(),
    DeliveryboyProfile(),
  ];

  final String url = Api_Config.clientListApi;
  var token;
  List data;
  // List<String> test = ["1","2"];

  @override
  Future<void> initState() {
    this.fetchClients();
    super.initState();
  }

  var list = new List();

  @override
  Widget build(BuildContext context) {
    // token = ModalRoute.of(context).settings.arguments;
    // print("Only token : $token");
    // print("token : $token");
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text("Client List"),
      // ),
      // drawer: new Drawer(
      //   child: new ListView(
      //     children: <Widget>[
      //       new UserAccountsDrawerHeader(
      //         accountName: new Text('Hitesh Moorjani'),
      //         accountEmail: null,
      //         currentAccountPicture: new GestureDetector(
      //           child: new CircleAvatar(
      //             backgroundImage: new AssetImage('assets/as.png'),
      //           ),
      //         ),
      //       ),
      //       new ListTile(
      //           title: new Text('Client List'),
      //           onTap: () {
      //             Navigator.of(context).pop();
      //             Navigator.of(context).push(new MaterialPageRoute(
      //                 builder: (BuildContext context) => new ClientList()));
      //           }),
      //       new ListTile(
      //           title: new Text('Pickup Order History'),
      //           trailing: new Icon(Icons.history),
      //           onTap: () {
      //             //Navigator.of(context).pop();
      //             Navigator.of(context).push(new MaterialPageRoute(
      //                 builder: (BuildContext context) =>
      //                     new DeliveryboyPickupOrderHistory()));
      //           }),
      //           new ListTile(
      //           title: new Text('Return Order History'),
      //           trailing: new Icon(Icons.history),
      //           onTap: () {
      //             //Navigator.of(context).pop();
      //             Navigator.of(context).push(new MaterialPageRoute(
      //                 builder: (BuildContext context) =>
      //                     new DeliveryboyReturnOrderHistory()));
      //           }),
      //       new Divider(),
      //       new ListTile(
      //         title: new Text('Close'),
      //         trailing: new Icon(Icons.cancel),
      //         onTap: () => Navigator.of(context).pop(),
      //       ),
      //       new Divider(),
      //       // new ListTile(
      //       //     title: new Text('Logout'),
      //       //     trailing: new Icon(Icons.account_circle),
      //       //     onTap: () {
      //       //       globals.authToken = null;
      //       //       Navigator.of(context).pop();

      //       //       Navigator.pushReplacement(
      //       //           context,
      //       //           MaterialPageRoute(
      //       //               builder: (BuildContext context) => MyApp()));

      //       //       // Navigator.of(context).push(
      //       //       //   new MaterialPageRoute(
      //       //       //       builder: (BuildContext context) => new MyApp()),
      //       //       // );
      //       //     }),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          Icon(
            Icons.verified_user,
            size: 20,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.add,
            size: 20,
            color: Colors.blueAccent,
          ),
          Icon(
            Icons.list,
            size: 20,
            color: Colors.blueAccent,
          ),
          // Icon(Icons.favorite,size: 20,color: Colors.blueAccent,),
          Icon(
            Icons.account_circle,
            size: 20,
            color: Colors.blueAccent,
          ),
        ],
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.easeInCirc,
        index: _currentIndex,
        onTap: (index) {

          print('index is : $index');
          setState(() {
            _currentIndex = index;
          });
          // if (index == 0) {
          // } else if (index == 1) {
          //   //Pickup order history

          //   Navigator.of(context).push(new MaterialPageRoute(
          //       builder: (BuildContext context) =>
          //           new DeliveryboyPickupOrderHistory()));
          // } else if (index == 2) {
          //   // return Order History
          //   Navigator.of(context).push(new MaterialPageRoute(
          //       builder: (BuildContext context) =>
          //           new DeliveryboyReturnOrderHistory()));
          // } else if (index == 3) {
          //   // Profile
          //   this.profile();
          // }
        },
      ),
      body: _children[_currentIndex],
      // body: new ListView.builder(
      //   itemCount: data == null ? 0 : data.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     var post = data[index]['id'];
      //     return new Container(
      //       child: new Center(
      //         child: new Column(
      //           crossAxisAlignment: CrossAxisAlignment.stretch,
      //           children: <Widget>[
      //             new Card(
      //               child: new Container(
      //                   /*child: new Text(data[index]['company_name'], style: TextStyle(
      //                     fontSize: ScreenUtil.getInstance().setSp(30),
      //                     fontFamily: "Raleway",
      //                     letterSpacing: .6
      //                 ),),*/

      //                   child: new ListTile(
      //                 title: Text(
      //                   data[index]['company_name'],
      //                   style:
      //                       TextStyle(fontFamily: "Raleway", letterSpacing: .6),
      //                 ),
      //                 subtitle: Text(
      //                   data[index]['address'],
      //                   style:
      //                       TextStyle(fontFamily: "Raleway", letterSpacing: .6),
      //                 ),
      //                 onTap: () => onTapped(post),
      //               )

      //                   // padding: const EdgeInsets.all(20.0),
      //                   ),
      //             )
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }

  onTapped(int id) {
    print(id);
    globals.clientId = id;

    showDialog(
        context: context,
        builder: (BuildContext context) => FancyDialog(
              title: "Select Pickup or Return",
              descreption: "",
            ));
  }

  Future<void> profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('usertype');
    prefs.remove('authToken');
  }
  /*onTapped(int id){
    print(id);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => ClientList()),);

    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => TemplateButtonGift(options),
    );

    popup.show(
      title: '',
      content: '',
      actions: [

        popup.button(

          label: 'Pickup',
          onPressed: () {
            popup.close;
            //var pop = Navigator.of(context).pop;
          }

          */ /*onPressed: (){

            //Navigator.push(context, MaterialPageRoute(builder: (context) => PickupItems()));
            Navigator.of(context).pop;
          }*/ /*
          //onPressed: Navigator.push(context, MaterialPageRoute(builder: (context) => ClientList()),),
        ),
        popup.button(
          label : 'Return',
         onPressed: (){
            popup.close;
    }
         // onPressed: Navigator.of(context).pop,
         */ /* onPressed : (){

            Navigator.push(context, MaterialPageRoute(builder: (context) => ReturnItems()));
            Navigator.of(context).pop;
          }*/ /*
        )
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );


  }*/

  Future<String> fetchClients() async {
    //var response = await http.get(url, headers: {"Authorization" : "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6Ijc3YTAzYWIyODAzNmNhNjBiYzExNTVmNjlhMTZlYjM4MDU4ODI3NWJjZWJjMmZiY2ZiYmQ3Y2EzNTkzOGE3Yjk5YjE5YjNmYjJlZTYzZmM1In0.eyJhdWQiOiI1IiwianRpIjoiNzdhMDNhYjI4MDM2Y2E2MGJjMTE1NWY2OWExNmViMzgwNTg4Mjc1YmNlYmMyZmJjZmJiZDdjYTM1OTM4YTdiOTliMTliM2ZiMmVlNjNmYzUiLCJpYXQiOjE1Nzk5MzYxMjEsIm5iZiI6MTU3OTkzNjEyMSwiZXhwIjoxNjExNTU4NTIxLCJzdWIiOiI4OCIsInNjb3BlcyI6W119.eJjWKnHvA2x1n9d2-awdmhrZ1WgOzZNwK9PTMrm6S-TljJJRSiTnhPf-OZ1V2X7V_GJPmyfVnRdXJSbA9kYABaBHqC8D8k1yMDYH4ThBIJVfuSJ7mOAjXkyOFyuXkE1XIoiUppNdnaYIHK2rWnpuHF4_RIjGij3RHZZxzcV3WAxw8RlqsHjHqSwBcbmXLb6z2VG1pFiymiLNkxUO1oJEJddTIVaKEZljC2wWpFtlFI9kmpJ6nJkWnVVBk0jG2_J7QnCXFb03qQkpirbWIq3UI3g-R2BYbqxC5x0TmYMKigxj1IJKGL3BVUvfKKjgpkfdAJN2QF7sTjdiarfi3CmQHceRw0dxQ-REUzrrfMbZcn1NclralLnwMVR5ERJr38vyabxnHI9g7I2pkIa_gRn7kh5wgWuJ45rDJ-M9cGu0hGn8AOnhzNMeO5pmfOcsyUh4CiIl4sX7DgtWj07JuMsUXl-dnW1fckyk5iTSGbxZknYFiJdX2CYXUxonht3T4x6wEI3T3YWn6ii7TEZJJrzG8hV-lRYhaKVnCCHJJ1YpaJdFKb_neJADgPxcM0deUGmnyCpda_DuUsq5ikHaxyoXUBn5xEJRJiAC4w80IsesU5qafpG9MByIhQl_0NkCryxKXBNLDyyYpMcdxmru_3RIAB2H8rfN2X-yjH5SpojFkCo"});
    //print("Bearer " "$token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authToken = prefs.getString('authToken');
    // var authToken = globals.authToken;

    //print("Token : Bearer " "$authToken");
    var response =
        await http.get(url, headers: {"Authorization": "Bearer " "$authToken"});
    print(response.body);

    var convertDataToJson = json.decode(response.body);
    data = convertDataToJson['data'];
    print(data[0]['company_name']);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['data'];
    });
    return "Success";

    /*print(json.decode(response.body));
    Map<String, dynamic> client = json.decode(response.body);

    print(client['data'][0]['id']);

    print(client['data'].length);

    for(var i = 0;i<client['data'].length; i++){
      print(client['data'][i]['first_name']);
      list.add(client['data'][i]['first_name']);
    }
    print(list);
    return list;*/
  }
}
