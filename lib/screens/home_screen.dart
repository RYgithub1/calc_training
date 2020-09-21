import 'package:calc_training/screens/test_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<DropdownMenuItem<int>> _menuItems = List();  // to use this List within this class all.
  int _numberOfQuestions = 0;  // for QuestionSelection -> 基本的に初期値も定義する、null空だと、参照した際にnullでアプリ落ちる

  @override
  void initState() {
    super.initState();
    setMenuItems();  // 選択肢作成がここゆえ、ここでアプリ開始時に表示へ
    _numberOfQuestions = _menuItems[0].value;  // リストの一番上を表示ゆえ0。現在選択しているDropdownMenuItemのvalue

  }
  void setMenuItems() {
    // (v1)
    // _menuItems.add(DropdownMenuItem(value: 10, child: Text(10.toString()),));
    // _menuItcdems.add(DropdownMenuItem(value: 20, child: Text(20.toString()),));
    // _menuItems.add(DropdownMenuItem(value: 30, child: Text(30.toString()),));
    // (v3)cascade notationで書く場合省略可能
    _menuItems
    ..add(DropdownMenuItem(value: 10, child: Text(10.toString()),))
    ..add(DropdownMenuItem(value: 20, child: Text(20.toString()),))
    ..add(DropdownMenuItem(value: 30, child: Text(30.toString()),));
    // (v2)リストに格納する場合
    // _menuItems = [
    //   DropdownMenuItem(value: 10, child: Text(10.toString()),),
    //   DropdownMenuItem(value: 10, child: Text(10.toString()),),
    //   DropdownMenuItem(value: 10, child: Text(10.toString()),),
    // ];
  }


  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery.of(context).size.width;  // get size of HomeScreen
    var screenHeight = MediaQuery.of(context).size.height;
    print("logical pixel of Width: $screenWidth");
    print("logical pixel of Height: $screenHeight");

    return Scaffold(
      body: SafeArea(  // wrap by SafeArea -> multiDevise
        child: Center(
          child: Column(
            children: <Widget>[

              Image.asset("assets/images/image_title.png"),
              const SizedBox(height: 16.0),

              const Text(
                "select number and push START",
                style: TextStyle(fontSize: 12.0),
              ),
              const SizedBox(height: 75.0),

              DropdownButton(
                items: _menuItems,
                value: _numberOfQuestions,  // 値を直接入れるより再利用性 -> 上でプロパティを定義（型を）
              
                // // onChanged: (value) => print(value.toString()),
                // onChanged: (selectValue){
                //   // onChamgedのF12 -> typedef ValueChanged<T> = void Function(T value);
                //   // ValueChangedだけど中身は、function関数
                //   setState(() {
                //   _numberOfQuestions = selectValue;
                //   // print(_numberOfQuestions);
                //   });
                //   // _numberOfQuestions = selectValue;  // widget is Stone, so
                // },
                onChanged: (value) => changeDropdownItem(value),
                // 上でなく、メソッド参照下でも可
                // onChanged: changeDropdownItem,  // 引数を見えないところで渡す方法
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 16.0),  // all vs only
                  child: RaisedButton.icon(
                    color: Colors.brown,
                    // onPressed: () => print("nnn"),  // F12 ... () -> function without argument。onPressed/onChanged名前のない関数
                    onPressed: () => startTestScreen(context),
                    // TODO:
                    label: Text("START"),
                    icon: Icon(Icons.skip_next),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  changeDropdownItem(int value) {
    setState(() {
      _numberOfQuestions = value;
    });
  }

  startTestScreen(BuildContext context) {
    Navigator.push(
      context,
      // MaterialPageRoute(builder: (context) => TestScreen(_numberOfQuestions),),
      MaterialPageRoute(builder: (context) => TestScreen(numberOfQuestions: _numberOfQuestions),),  // named paramsでrouteへ飛ばす
    );
  }

}