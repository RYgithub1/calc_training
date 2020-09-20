import 'package:calc_training/screens/home_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';


void main() => runApp(MyApp());  // suggestFunction after "void main() => ru" , need ()


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Calc Trainig",
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

