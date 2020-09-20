import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(  // SafeAreaでくるむ -> multiDevise
        child: Column(
          children: <Widget>[

            Image.asset("assets/images/image.title.png"),
            Text("select number and push START"),
            // TODO:
            RaisedButton(
              onPressed: null,
              child: Text("START"),
            ),

          ],
        ),
      ),
    );
  }
}