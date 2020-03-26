import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/HomePage.dart';
import 'package:pickup_return/ClientWidgets/PendingPickupItems.dart';
import 'package:pickup_return/api_config.dart' as Api_Config;
import 'package:pickup_return/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:pickup_return/main.dart';
import 'package:toast/toast.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String dropdownValue = 'Select State';
  String dropdownValuecity = 'Select City';
  List data = ['Select State'];
  List citiesData = ['Select City'];
  var convertDataToJson;

  final companyNameText = TextEditingController();
  final firstNameText = TextEditingController();
  final lastNameText = TextEditingController();

  final cellPhoneText = TextEditingController();
  final emailText = TextEditingController();
  final passwordText = TextEditingController();
  final addressText = TextEditingController();

  @override
  void initState() {
    fetchCitiesAndStates();
    // citiesData = List.from(citiesData)..addAll(data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final companyName = TextFormField(
      keyboardType: TextInputType.text,
      controller: companyNameText,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'Company Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final firstName = TextFormField(
      keyboardType: TextInputType.text,
      controller: firstNameText,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final lastName = TextFormField(
      controller: lastNameText,
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'Last Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final cellPhone = TextFormField(
      controller: cellPhoneText,
      keyboardType: TextInputType.phone,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'Cell Phone',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final email = TextFormField(
      controller: emailText,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,

      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      controller: passwordText,
      autofocus: false,
      // initialValue: 'some password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final address = TextFormField(
      controller: addressText,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Address',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    List<DropdownMenuItem> states = data.map((item) {
      return DropdownMenuItem(
        child: Text(item),
        value: item,
      );
    }).toList();

    if (states.isEmpty) {
      states = [
        DropdownMenuItem(
          child: Text(dropdownValue),
          value: dropdownValue,
        )
      ];
    }

    final state = DropdownButton(
      items: states,
      onChanged: (newVal) => setState(() => {
            dropdownValuecity = 'Select City',
            citiesData = ['Select City'],
            dropdownValue = newVal,
            citiesData = List.from(citiesData)
              ..addAll(convertDataToJson['data'][newVal]),
            print(convertDataToJson['data'][newVal]),
            print('cities data : '),
            print(citiesData),
          }),
      value: dropdownValue,
    );

    List<DropdownMenuItem> cities = citiesData.map((item) {
      return DropdownMenuItem(
        child: Text(item),
        value: item,
      );
    }).toList();

    if (cities.isEmpty) {
      cities = [
        DropdownMenuItem(
          child: Text(dropdownValuecity),
          value: dropdownValuecity,
        )
      ];
    }

    final city = DropdownButton(
      items: cities,
      onChanged: (newVal) => setState(() => {
            dropdownValuecity = newVal,
          }),
      value: dropdownValuecity,
    );

    // final state = Padding(
    //   padding: EdgeInsets.only(left: 12.0),
    //  final state = DropdownButton<String>(
    //     value: dropdownValue,
    //     // icon: Icon(Icons.arrow_downward),
    //     iconSize: 24,
    //     elevation: 24,
    //     style: TextStyle(color: Colors.lightBlueAccent),
    //     underline: Container(
    //       // padding: EdgeInsets.all(20.0),
    //       height: 2,
    //       margin: EdgeInsets.only(left: 10.0,right: 5.0),
    //       color: Colors.lightBlueAccent,
    //     ),
    //     onChanged: (String newValue) {
    //       setState(() {
    //         dropdownValue = newValue;
    //       });
    //     },
    //     items: data
    //         .map((value) {
    //       return DropdownMenuItem<String>(
    //         value: value,
    //         child: SizedBox(
    //           width: 100.0, // for example
    //           child: Text(value, textAlign: TextAlign.center),
    //         ),
    //       );
    //     }).toList(),

    // );

    // final city = DropdownButton<String>(
    //     value: dropdownValuecity,
    //     // icon: Icon(Icons.arrow_downward),
    //     iconSize: 24,
    //     elevation: 24,
    //     style: TextStyle(color: Colors.lightBlueAccent),
    //     underline: Container(
    //       // padding: EdgeInsets.all(20.0),
    //       height: 2,
    //       margin: EdgeInsets.only(left: 10.0,right: 5.0),
    //       color: Colors.lightBlueAccent,
    //     ),
    //     onChanged: (String newValue) {
    //       setState(() {
    //         dropdownValuecity = newValue;
    //       });
    //     },
    //     items: <String>['Vadodara', 'Mumbai', 'Jaipur', 'Dehradun']
    //         .map<DropdownMenuItem<String>>((String value) {
    //       return DropdownMenuItem<String>(
    //         value: value,
    //         child: SizedBox(
    //           width: 100.0, // for example
    //           child: Text(value, textAlign: TextAlign.center),
    //         ),
    //       );
    //     }).toList(),

    // );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          this.clientRegistration();
          // Navigator.of(context).pushNamed(HomePage.tag);
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Signup', style: TextStyle(color: Colors.white)),
      ),
    );

    //  final forgotLabel = FlatButton(
    //   child: Text(
    //     'Forgot password?',
    //     style: TextStyle(color: Colors.black54),
    //   ),
    //   onPressed: () {},
    // );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            companyName,
            SizedBox(height: 8.0),
            firstName,
            SizedBox(height: 8.0),
            lastName,
            SizedBox(height: 8.0),
            cellPhone,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 8.0),
            address,
            SizedBox(height: 8.0),
            state,
            SizedBox(height: 8.0),
            city,
            SizedBox(height: 24.0),
            registerButton,
          ],
        ),
      ),
    );
  }

  fetchCitiesAndStates() async {
    await http.get(Api_Config.citiesAndStates).then((http.Response response) {
      final int statusCode = response.statusCode;

      print("status code :   $statusCode ");
      // print(response.body);

      // var sample = {
      //   "data" : {
      //     "Maharashtra":[{"city":"Mumbai"},{"city":"Pune"}],
      //     "Gujarat":[{"city":"Vadodara"},{"city":"Surat"}],

      //   }
      // };

      // print(sample['data'][0]);
      setState(() {
        convertDataToJson = json.decode(response.body);
        convertDataToJson['data'].forEach((k, v) => {
              print(k),
              data.add(k),
            });
      });

      print('test : ');
      print(convertDataToJson['data']['Gujarat']);
      print(convertDataToJson);

      convertDataToJson.forEach((k, v) => print('${k}'));
    });
  }

  Future<void> clientRegistration() async {
    String passwordPattern =
        r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';

    // RegExp regExp = new RegExp(passwordPattern);
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailText.text);
    bool cellValid = RegExp(r"^[0-9]{8,25}").hasMatch(cellPhoneText.text);
    if (emailValid &&
        cellValid &&
        companyNameText.text.isNotEmpty &&
        firstNameText.text.isNotEmpty &&
        lastNameText.text.isNotEmpty) {
      var body = {
        'company_name': companyNameText.text,
        'first_name': firstNameText.text,
        'last_name': lastNameText.text,
        'cell_phone': cellPhoneText.text,
        'email': emailText.text,
        'password': passwordText.text,
        'state': dropdownValue,
        'city': dropdownValuecity,
        'address': addressText.text,
      };
      await http
          .post(Api_Config.clientRegistration, body: body)
          .then((http.Response response) {
        final int statusCode = response.statusCode;
        print(statusCode);
        print(response.body);
        if (statusCode == 201) {
          Toast.show(
            "Registration successfully completed!",
            context,
            duration: 2,
            gravity: Toast.CENTER,
            textColor: Colors.yellowAccent,
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => MyApp()));
        }
      });
    } else {
      if (companyNameText.text.isEmpty) {
        Toast.show(
          "Company name is required field",
          context,
          duration: 4,
          gravity: Toast.CENTER,
          textColor: Colors.yellowAccent,
        );
      } else if (firstNameText.text.isEmpty) {
        Toast.show(
          "First name is required field.",
          context,
          duration: 4,
          gravity: Toast.CENTER,
          textColor: Colors.yellowAccent,
        );
      } else if (lastNameText.text.isEmpty) {
        Toast.show(
          "Last name is required field.",
          context,
          duration: 4,
          gravity: Toast.CENTER,
          textColor: Colors.yellowAccent,
        );
      } else if (!cellValid) {
        Toast.show(
          "The cell phone must be between 8 and 25 digits.",
          context,
          duration: 4,
          gravity: Toast.CENTER,
          textColor: Colors.yellowAccent,
        );
      } else if (!emailValid) {
        Toast.show(
          "Please enter valid Email Address",
          context,
          duration: 4,
          gravity: Toast.CENTER,
          textColor: Colors.yellowAccent,
        );
      }
    }
  }
}
