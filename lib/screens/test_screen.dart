import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';



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
  // ----- number -----
  // String numberOfRemaining;
  int numberOfRemaining = 0;
  // var numberOfCorrect;
  int numberOfCorrect = 0;
  // var numberOfRate;
  int numberOfRate = 0;
  // ----- question -----
  int questionLeft = 0;
  int questionRight = 0;
  String operator = "";
  String answerString = "";  // minus -> String
  // ----- soundpool -----
  Soundpool soundpool;
  int soundIdCorrect = 0;
  int soundIdInCorrect = 0;
  // ----- button && image -----
  bool isCalcButtonEnabled = false;  // if -> bool型
  bool isAnswerCheckButtonEnabled = false;
  bool isBackButtonEnabled = false;
  bool isCorrectInCorrectImageEnabled = false;
  bool isEndMessageEnabled = false;
  // ----- correct or not -----
  bool isCorrect = false;  // 正解の判定



  // ==================================

  // --- judge sound ---
  @override
  void initState() {
    super.initState();
    numberOfCorrect = 0;  // sound発生に合わせ、表示数字を0クリアするため
    numberOfRate = 0;
    numberOfRemaining = widget.numberOfQuestions; // 書き換える。

    initSounds(); // 外だしメソッド「async-await」「可読性」、あっちでwidget型
    setQuestion();
  }

  void initSounds() async{ // initStateは離婚できないので外だし側でasync
    try{
      soundpool = Soundpool(); // 音用のインスタンス作成
      soundIdCorrect = await loadSound("assets/sounds/sound_correct.mp3"); // 外だしメソとパス引数
      soundIdInCorrect = await loadSound("assets/sounds/sound_incorrect.mp3"); // 外だしメソとパス引数
      // build()回して変化確定へsetState
      setState(() {});
    } on IOException catch(error) {
      print("エラー内容：$error");
    }
  }
  Future<int> loadSound(String soundPath) {  // get path as a awgument.  -> id judge
    // type of async-await retrun is FUTURE
    return rootBundle.load(soundPath).then((value) => soundpool.load(value));  // soundは、rootBundlenのload(path)に、soundPathを格納し対応させる。最後にthen/catchError
    // then((value) => soundpool.load(value)); バイトデータを持ってきている
  }
  @override
  void dispose() {
    super.dispose();
    soundpool.release();
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
      // onPressed: () => print(numString),
      onPressed: isCalcButtonEnabled ? () => inputAnswer(numString) : null,  //ボタン押時の処理  ->（追加）使えるならそのまま、falseならnull
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
            // onPressed: null,
            // onPressed: () => answerCheck(),  // 答え合わせボタンが押せるタイミング＝電卓ボタンisCalcButtonEnabledが押せるだけ条件
            onPressed: isCalcButtonEnabled ? () => answerCheck() : null,  // 「?()=>」で、「if文 (true)左:(false)右」


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
              // onPressed: null, // 戻るボタンが押せる＝ 終了した時、画面遷移する！
              onPressed: isBackButtonEnabled ? () => closeTestScreen() : null,


              child: Text("戻る", style: TextStyle(fontSize: 14.0),)
            ),
          ),
        ),
      ),
    );

  }

  // --- 上に重ねるもの程下に書く ---
  // == マルバツ画像 ===
  Widget _correctIncorrectImage() {  // 重ねるマルバツ
    // return Center(child: Image.asset("assets/images/pic_correct.png"));
    // if(isCorrectInCorrectImageEnabled == true){
    if(isCorrectInCorrectImageEnabled){
      // 追加、正解時
      // if(isCorrect = true){ // 正解の場合
      if(isCorrect == true){ // 正解の場合
        return Center(child: Image.asset("assets/images/pic_correct.png"));
      } // 不正解の場合（早期リターン）
      return Center(child: Image.asset("assets/images/pic_incorrect.png"));
    
    } else {
      return  Container();
    }
  }
  // === テスト終了メッセージ ===
  Widget _endMessage() { // 重ねるメッセージ
    // return Center(child: Text("Finish", style: TextStyle(fontSize: 60, color: Colors.yellow),));
    if(isEndMessageEnabled == true) {
      return Center(child: Text("Finish", style: TextStyle(fontSize: 60, color: Colors.yellow),));
    } else {
      return Container();

    }
  }


  // === 問題を出す ====
  void setQuestion() {
    // 問題出題時にtrueにするものをセット
    isCalcButtonEnabled = true;
    isAnswerCheckButtonEnabled = true;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = false;
    isEndMessageEnabled = false;
    // 問題を出す時は、最初は不正解状態が良いので下false
    isCorrect = false;
    answerString = ""; // 次の問題始まったら解答欄を一度空欄にする


    Random random = Random();
    questionLeft = random.nextInt(100) + 1; //f12->from 0, inclusive, to [max], exclusive.->100入れるに+1
    questionRight = random.nextInt(100) + 1;
    // ±２択 -> if文で文字列変える
    if (random.nextInt(2) + 1 == 1) {  // classの中を想定してます
      operator = "+";
    } else {
      operator = "-";
    }
    setState(() {});  // 変化通知。かつ2問目以降の反映のため
  }


  // === 電卓入力値の場合分け =====
  inputAnswer(String numString) {
    setState(() {
      if(numString == "C") {  // 電卓計算例外
        answerString = ""; //「中身が何もない」を後ろに追加。初期何もなしへ
        return;  // if文の早期リターン(else使わない)
      }
      if(numString == "-") {
        if(answerString == "") answerString = "-";  // 省略パターン書き方
        return;
      }
      if(numString == "0"){
        if(answerString != "0" && answerString != "-"){  // answerStringが0でも-でもない時、追加して良い
          answerString = answerString + numString;
          return;
        }
      }
      if(answerString == "0"){  // head number が0 なら入れ替える
        answerString =  numString;
        return;
      }
      answerString = answerString + numString;  // 数字押下の反映 -> 石の変化 -> setStateでwrap -> 電卓の例外対応へif
    });
  }


  // +===  和差積商の計算 +==========
  answerCheck() {
    if(answerString == "" || answerString == "-"){  // 入力値が問題ないかまずチェック
      return;
    }
    // ボタンの押下可否を設定
    isCalcButtonEnabled = false;  // 電卓ボタン押せない -> onPressed: isCalcButtonEnabled ?へ
    isAnswerCheckButtonEnabled = false;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = true;
    isEndMessageEnabled = false;

    // 計算するたびに、問題数をへらす
    numberOfRemaining -= 1;

    // 入力値と計算結果が同じならマル、falseならバツ
    // 入力値
    var myAnswer = int.parse(answerString).toInt();
    // 自動計算値
    var realAnswer = 0;
    if(operator == "+"){
      realAnswer = questionLeft + questionRight;
    } else {
      realAnswer = questionLeft - questionRight;
    }
    // 比較
    if(myAnswer == realAnswer){
      isCorrect = true;
      // soundpool.play(soundId)
      soundpool.play(soundIdCorrect);
      // print("gg");
      // numberOfCorrect = numberOfCorrect + 1;
      numberOfCorrect += 1;  // 正解したら正解数を増やす
    } else {
      isCorrect = false;
      soundpool.play(soundIdInCorrect);
    }


    // 正解率は数学
    numberOfRate = ((numberOfCorrect / (widget.numberOfQuestions - numberOfRemaining)) *100).toInt();


    // 残り問題数有無で、画面遷移場合分け
    if(numberOfRemaining == 0){  // 残り問題数ない? ->ボタンに変化
      // 残り問題数ない場合
      isCalcButtonEnabled = false;  // 電卓ボタン押せない -> onPressed: isCalcButtonEnabled ?へ
      isAnswerCheckButtonEnabled = false;
      isBackButtonEnabled = true;
      isCorrectInCorrectImageEnabled = true;
      isEndMessageEnabled = false;
    } else {
      // 残り問題数あり場合
      Timer(  // 1s after , puts next question
        Duration(seconds: 1),
        () => setQuestion()
      );
    }

    setState(() {});


  }

  closeTestScreen() {
    // popとpop replaceどっち？
    // home_screen がpushゆえpopのみ
    Navigator.pop(context);
  }

}


//  次画面に渡したい時は、argument付きのコンストラクタを定義


// table -> テーブル中身の要素、ボタンの 大きさを変えられない、が実装は早い