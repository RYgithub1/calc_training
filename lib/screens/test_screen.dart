import 'package:flutter/material.dart';



class TestScreen extends StatefulWidget {
  // var numberOfQuestions;
  final numberOfQuestions;  // const vs final
  // TestScreen(this.numberOfQuestions);
  TestScreen({this.numberOfQuestions});
  // {}追加 -> home_screen でnamed paramsパラメーター の形で呼べる。順番無視できるのでpractical

  @override
    _TestScreenState createState() => _TestScreenState();
}



class _TestScreenState extends State<TestScreen> {
  // String numberOfRemaining;
  int numberOfRemaining = 0;
  // var numberOfCorect;
  int numberOfCorect = 0;
  // var numberOfRate;
  int numberOfRate = 0;

  int questionLeft = 5;
  int questionRight = 06;
  String operator = "+";
  String answerString = "100";


  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                _scorePart(),  // score表示部分
                _questionPart(), // 問題表示部分
                _calcButton(), // 電卓ボタン
                _answerCheckButton(), // 答え合わせボタン
                _backButton(), // 戻るボタン
              ],

        ),
      ),
    );
  }

  // 可読性と再利用性 -> 外だし関数の戻り値の型はWidget（全てWidgetを介するため）
  Widget _scorePart() {
    return Padding(
      padding: const EdgeInsets.only(top:8.0, right:8.0, left:8.0),
      child: Table(
        children: [
          TableRow(
            children: [
              // 変化しないので文字ベタ打ち
              Center(child: Text("残り問題数", style: TextStyle(fontSize: 10.0),)),
              Center(child: Text("正解数", style: TextStyle(fontSize: 10.0),)),
              Center(child: Text("正答率", style: TextStyle(fontSize: 10.0),)),
            ]
          ),
          TableRow(
            children: [
              // 変化するので変数
              // comm. -> create field -> type
              Center(child: Text(numberOfRemaining.toString(), style: TextStyle(fontSize: 18.0),)),
              Center(child: Text(numberOfCorect.toString(), style: TextStyle(fontSize: 18.0),)),
              Center(child: Text(numberOfRate.toString(), style: TextStyle(fontSize: 18.0),)),
            ]
          ),
        ],
      ),
    );
  }

  Widget _questionPart() {
    // return Container();
    return Row(
      children: <Widget>[
        Expanded(flex:2, child: Text(questionLeft.toString(), style: TextStyle(fontSize: 36.0),)),
        Expanded(flex:1, child: Text(operator, style:  TextStyle(fontSize: 36.0),)),
        Expanded(flex:2, child: Text(questionRight.toString(), style:  TextStyle(fontSize: 36.0),)),
        Expanded(flex:1, child: Text("=", style:  TextStyle(fontSize: 36.0),)),
        Expanded(flex:3, child: Text(answerString, style:  TextStyle(fontSize: 60.0),)),

      ],
    );
  }

  Widget _calcButton() {
    return Container();
  }



  Widget _answerCheckButton() {
    return Container();

  }

  Widget _backButton() {
    return Container();

  }
}


//  次画面に渡したい時は、argument付きのコンストラクタを定義


// table -> テーブル中身の要素、ボタンの 大きさを変えられない、が実装は早い