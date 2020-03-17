import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsflutterprogect/data/models.dart';
import 'package:newsflutterprogect/data/network/network.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainPage> {
  //List _items = <Widget>[];
  Future<List<Article>> news;
  List<Article> items;

  /*updateItems(List<Widget> items) {
    setState(() {
      //_items = items;
    });
  }*/

  void updateItems(List<Article> articles) {
    setState(() {
      items = articles;
    });
  }

  @override
  void initState() {
    super.initState();
    print("initState()");
    /*print("init state");
    _items.clear();
    for (int i = 0; i < 50; i++) {
      _items.add(getRow(i));
    }*/
    NetworkDataSource.loadAllNews().then((value) =>
    {
     /* value.forEach((element) {
        print("items loaded ${element.content}");
      }),*/
     // items = value
      updateItems(value)
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items == null || items.isEmpty) {
      return Center(
        child: Text("No news"),
      );
    } else {
      return ListView.builder(
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          });
    }
  }

  Widget getRow(int position) {
    return Center(
      child: Text(items[position].content),
    );
  }

/*void updateItems() async {
    items = await news;
  }*/

}
