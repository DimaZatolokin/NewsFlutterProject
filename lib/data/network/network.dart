import 'dart:convert';

import 'package:http/http.dart';
import 'package:newsflutterprogect/data/models.dart';
import 'package:newsflutterprogect/data/network/responses.dart';

class NetworkDataSource {
  static Future<List<Article>> loadAllNews() async {
    String url =
        "http://newsapi.org/v2/everything?q=bitcoin&from=2020-02-17&sortBy=publishedAt&apiKey=2193e64fdf2346a7ae1461a9f48ac755";
    Response response = await get(url);
    if (response.statusCode == 200) {
      LoadNewsResponse loadNewsResponse =
          LoadNewsResponse.fromJson(json.decode(response.body));
      /*loadNewsResponse.articles.forEach((element) {
        print(element.toString());
      });*/
      //print(loadNewsResponse.articles.toString());
      /*List<Article> articles = List();
      loadNewsResponse.articles.forEach((element) {
        articles.add(Article.fromJson(json.decode(element.toString())));
      });*/
      return loadNewsResponse.articles;
    } else {
      throw Exception('Failed to load news ${response.statusCode}');
    }
  }
}
