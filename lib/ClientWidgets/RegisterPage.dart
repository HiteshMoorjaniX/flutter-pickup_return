import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/HomePage.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String dropdownValue = 'Gujarat';
  String dropdownValuecity = 'Vadodara';
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
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'First Name',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final lastName = TextFormField(
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
      autofocus: false,
      // initialValue: 'some password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    // final state = Padding(
    //   padding: EdgeInsets.only(left: 12.0),
     final state = DropdownButton<String>(
        value: dropdownValue,
        // icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 24,
        style: TextStyle(color: Colors.lightBlueAccent),
        underline: Container(
          // padding: EdgeInsets.all(20.0),
          height: 2,
          margin: EdgeInsets.only(left: 10.0,right: 5.0),
          color: Colors.lightBlueAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['Gujarat', 'Maharashtra', 'Rajasthan', 'Uttarakhand']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
              width: 100.0, // for example
              child: Text(value, textAlign: TextAlign.center),
            ),
          );
        }).toList(),
      
    );

    final city = DropdownButton<String>(
        value: dropdownValuecity,
        // icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 24,
        style: TextStyle(color: Colors.lightBlueAccent),
        underline: Container(
          // padding: EdgeInsets.all(20.0),
          height: 2,
          margin: EdgeInsets.only(left: 10.0,right: 5.0),
          color: Colors.lightBlueAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValuecity = newValue;
          });
        },
        items: <String>['Vadodara', 'Mumbai', 'Jaipur', 'Dehradun']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: SizedBox(
              width: 100.0, // for example
              child: Text(value, textAlign: TextAlign.center),
            ),
          );
        }).toList(),
      
    );


    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(HomePage.tag);
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
}
