import 'package:newsflutterprogect/data/models.dart';

class LoadNewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  LoadNewsResponse(this.status, this.totalResults, this.articles);

  factory LoadNewsResponse.fromJson(Map<String, dynamic> json) {
    var articlesJsonList = json['articles'] as List;

    return LoadNewsResponse(
        json['status'], json['totalResults'], articlesJsonList.map((e) => Article.fromJson(e)).toList());
  }
}
