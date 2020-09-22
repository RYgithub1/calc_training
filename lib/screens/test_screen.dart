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
  // --- number ---
  // String numberOfRemaining;
  int numberOfRemaining = 0;
  // var numberOfCorrect;
  int numberOfCorrect = 0;
  // var numberOfRate;
  int numberOfRate = 0;

  // --- question ---
  int questionLeft = 5;
  int questionRight = 6;
  String operator = "+";
  String answerString = "100";  // minus -> String

  // --- judge sound ---
  @override
  void initState() {
    super.initState();
    numberOfCorrect = 0;  // sound発生に合わせ、表示数字を0クリアするため
    numberOfRate = 0;
    numberOfRemaining = widget.numberOfQuestions; // 書き換える。

    setQuestion();
      }
    
    
    
      @override
      Widget build(BuildContext context) {
        return SafeArea(
              child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    Column(  // 上にstackするもの程下に書く -> 階層に注意
                      children: <Widget>[
                        _scorePart(),  // score表示部分
                        _questionPart(), // 問題表示部分
                        _calcButtons(), // 電卓ボタン
                        _answerCheckButton(), // 答え合わせボタン
                        _backButton(), // 戻るボタン
                      ],
                    ),
                    _correctIncorrectImage(),  // 上に重ねる丸バツをColumnと並列階層に
                    _endMessage(),  //上に重ねるメッセージも
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
                  Center(child: Text(numberOfCorrect.toString(), style: TextStyle(fontSize: 18.0),)),
                  Center(child: Text(numberOfRate.toString(), style: TextStyle(fontSize: 18.0),)),
                ]
              ),
            ],
          ),
        );
      }
    
      Widget _questionPart() {
        // return Container();
        return Padding(
          padding: const EdgeInsets.only(top:80.0, right:8.0, left:8.0),
          child: Row(
            children: <Widget>[
              Expanded(flex:2, child: Center(child: Text(questionLeft.toString(), style: TextStyle(fontSize: 36.0),),),),
              // Expanded(flex:2, Widget: Center(child: Text(questionLeft.toString(), style: TextStyle(fontSize: 36.0),),),),
              Expanded(flex:1, child: Center(child: Text(operator, style:  TextStyle(fontSize: 30.0),))),
              Expanded(flex:2, child: Center(child: Text(questionRight.toString(), style:  TextStyle(fontSize: 36.0),))),
              Expanded(flex:1, child: Center(child: Text("=", style:  TextStyle(fontSize: 30.0),))),
              Expanded(flex:3, child: Center(child: Text(answerString, style:  TextStyle(fontSize: 60.0),))),
            ],
          ),
        );
      }
    
      Widget _calcButtons() {  // 最後に書くあまりのスペース全体へ拡大、テーブル使おう、機能同じ外だしメソ
        // return Container(
        return Expanded(  // デザインから下方にボタン＝間にスペースをexpandedで作成
          child: Padding(
            padding: const EdgeInsets.only(top:50.0, right:8.0, left:8.0),
            child: Table(
              children: [
                TableRow(
                  children: [
                    // _calcButton(),
                    _calcButton(7.toString()),
                    _calcButton("8"),
                    _calcButton("9"),
                  ]
                ),
                TableRow(
                  children: [
                    _calcButton("4"),
                    _calcButton("5"),
                    _calcButton("5"),
                  ]
                ),
                TableRow(
                  children: [
                    _calcButton("1"),
                    _calcButton("2"),
                    _calcButton("3"),
                  ]
                ),
                TableRow(
                  children: [
                    _calcButton("0"),
                    _calcButton("-"),
                    _calcButton("C"),
                  ]
                ),
              ],
            ),
          ),
        );
      }
      Widget _calcButton(String numString) {
        return RaisedButton(
          onPressed: () => print(numString),
          child: Text(numString, style: TextStyle(fontSize: 24.0)),
        );
    
      }
    
    
    
      Widget _answerCheckButton() {
        return Padding(
          padding: const EdgeInsets.only(top:20.0, right:8.0, left:8.0),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              color: Colors.pink,
              child: RaisedButton(  // 横に広げたいSizedBox and width
                onPressed: null,
                child: Text("答え合わせ", style: TextStyle(fontSize: 14.0),),
              ),
            ),
          ),
        );
      }
    
      Widget _backButton() {
        return Padding(
          // padding: const EdgeInsets.only(top:10.0, right:8.0, bottom:10.0, left:8.0),
          padding: const EdgeInsets.only(right:8.0, left:8.0),
          child: Container(
            // color: Colors.green,
            child: SizedBox(
              width: double.infinity,
              child: Container(
                color: Colors.green,
                child: RaisedButton(
                  // color: Colors.green,
                  onPressed: null,
                  child: Text("戻る", style: TextStyle(fontSize: 14.0),)
                ),
              ),
            ),
          ),
        );
    
      }
    
      // --- 上に重ねるもの程下に書く ---
      Widget _correctIncorrectImage() {  // 重ねるマルバツ
        return Center(child: Image.asset("assets/images/pic_correct.png"));
      }
      Widget _endMessage() { // 重ねるメッセージ
        return Center(child: Text("Finish", style: TextStyle(fontSize: 60, color: Colors.yellow),));
      }
    
      // --- 効果音 ---
      void setQuestion() {}

}


//  次画面に渡したい時は、argument付きのコンストラクタを定義


// table -> テーブル中身の要素、ボタンの 大きさを変えられない、が実装は早い