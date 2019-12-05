import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(
  MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    debugShowMaterialGrid: false,
    showSemanticsDebugger: false,
  )
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  int _listCount = 10;
  ScrollController _listCt;

  Fetch fetch = new Fetch(
    uri: "http://192.168.1.5:3000",
    query: "main",
  );

  @override
  void initState() {
    this._listCt = ScrollController()
      ..addListener((){
        if(this._listCt.offset >= this._listCt.position.maxScrollExtent){

          if(this._listCount < 40){
            setState(() {
              this._listCount += 10;
            });
          }

          else return;
        }
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            children: <Widget>[

              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width*0.2,
                  child: Text(
                    "아이디어스",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Form(
                  child: TextField(
                    onSubmitted: (String v) => print(v),
                    decoration: InputDecoration(
                      hintText: "클래스, 작가 검색",
                      filled: true,
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

        actions: <Widget>[

          Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[

                IconButton(
                  onPressed: () => print("asd"),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.grey,
                  ),
                ),

                Positioned(
                  top: 7,
                  right: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(9.0)
                    ),
                    child: Center(
                      child: Text(
                        "5",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )

        ],
      ),

      body: SingleChildScrollView(
        controller: _listCt,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[

              Stack(
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 30,
                    bottom: 10,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5.0
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.white
                        ),
                        child: Text("1/5"),
                      ),
                    ),
                  ),

                ],
              ),
              
              Container(
                width: MediaQuery.of(context).size.width,
                height: 280,
                margin: EdgeInsets.only(
                  top: 10.0,
                  right: 10.0,
                  left: 10.0
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3
                  ),
                  itemCount: 6,
                  padding: EdgeInsets.only(
                    top: 10.0
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, int index){
                    return GestureDetector(
                      onTap: () => pageMove( hTag: "메뉴$index" ),
                      child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Hero(
                                tag: "메뉴$index",
                                child: Icon(Icons.image),
                              ),
                            ),
                            Container(
                              child: Text("메뉴$index"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),

              Container(
                child: Column(
                  children: <Widget>[

                    Container(
                      margin:EdgeInsets.only(
                        top: 10.0
                      ),
                      padding: EdgeInsets.only(
                        left: 10.0
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "인기 금손 클래스",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0*_listCount,
                      padding: EdgeInsets.all(10.0),
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                        itemCount: _listCount,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, int index){
                          return GestureDetector(
                            onTap: () => pageMove( hTag: "컨텐츠${index+1}" ),
                            child: Container(
                              height: 180,
                              color: Colors.red[100],
                              margin: EdgeInsets.symmetric(
                                vertical: 10.0
                              ),
                              child: Center(
                                child: Text("컨텐츠${index+1}"),
                              )
                            )
                          );
                        }
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void pageMove({String hTag}){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          data: hTag,
        )
      )
    );
  }

}


class DetailPage extends StatefulWidget {
  var data;
  DetailPage({this.data});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with SingleTickerProviderStateMixin{

  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    controller =
      AnimationController(vsync: this, duration: Duration(seconds: 2),);

    animation = Tween(begin: 200.0, end: 300.0).animate(controller);

    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: widget.data,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child){
              return Container(
                width: animation.value,
                height: 200,
                color: Colors.red,
              );
            },
          ),
        ),
      ),
    );
  }
}


class Fetch{
  String uri;
  String query;

  Fetch({this.uri, this.query});

  Future<List<CardViewModel>> connect() async{
    final String url = _urlValidation(this.uri) + '/' + this.query;
    var res = await http.get(url);
    final List data = json.decode(res.body);
    return data.map((json) => CardViewModel.fromJson(json)).toList();
  }

  _urlValidation(String userInput){
    if(userInput[userInput.length] != "/") return userInput;
    return userInput.substring(0,userInput.length-1);
  }
}

class CardViewModel{
  String imageSrc;
  String maker;
  String title;
  int starCount;

  CardViewModel({this.imageSrc, this.maker, this.title, this.starCount});

  factory CardViewModel.fromJson(json) {
    return CardViewModel(
      imageSrc: json['imgeSrc'],
      maker: json['maker'],
      title: json['title'],
      starCount: json['starCount'],
    );
  }
}