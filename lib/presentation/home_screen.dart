import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsflutterprogect/presentation/additional_page.dart';
import 'package:newsflutterprogect/presentation/main_page.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      text: "NEWS",
                    ),
                    Tab(
                      text: "Another news",
                    )
                  ],
                ),
                title: Center(child: Text("World news"))),
            body: TabBarView(
              children: <Widget>[
                MainPage(),
                AdditionalPage(),
              ],
            ),
          )),
    );
  }
}
