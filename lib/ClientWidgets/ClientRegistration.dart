import 'package:flutter/material.dart';
import 'package:pickup_return/ClientWidgets/HomePage.dart';
import 'package:pickup_return/ClientWidgets/RegisterPage.dart';

class ClientRegistration extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    RegisterPage.tag: (context) => RegisterPage(),
    HomePage.tag: (context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: RegisterPage(),
      routes: routes,
    );
  }
}
