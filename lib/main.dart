import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newsflutterprogect/data/network/network.dart';
import 'package:newsflutterprogect/presentation/home_screen.dart';
import 'package:newsflutterprogect/presentation/main_page.dart';

void main() {
  _initAppData();
  runApp(MyApp());
}

void _initAppData() {
  var flutterSecureStorage = FlutterSecureStorage();
  _writeToSecureStorage(flutterSecureStorage, KEY_NEWS_API_KEY,
      "2193e64fdf2346a7ae1461a9f48ac755");
}

void _writeToSecureStorage(
    FlutterSecureStorage secureStorage, String key, String value) async {
  await secureStorage.write(key: key, value: value);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
