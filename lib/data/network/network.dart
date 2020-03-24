import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:newsflutterprogect/data/models.dart';
import 'package:newsflutterprogect/data/network/responses.dart';
import 'package:newsflutterprogect/presentation/utils.dart';

const String KEY_NEWS_API_KEY = "KEY_NEWS_API_KEY";

abstract class NetworkDataSource {
  Future<List<Article>> loadNewsByKey(String key);
}

class NetworkDataSourceImpl implements NetworkDataSource {
  FlutterSecureStorage _secureStorage;

  NetworkDataSourceImpl(this._secureStorage);

  Future<List<Article>> loadNewsByKey(String key) async {
    var apiKey = await _secureStorage.read(key: KEY_NEWS_API_KEY);
    String url =
        "${_ApiUrls.BASE_URL}${_ApiUrls.END_POINT_EVETYTHING}?q=$key&from=${DateTimeUtils.getDateInServerFormat(DateTime.now())}&sortBy=publishedAt&apiKey=2193e64fdf2346a7ae1461a9f48ac755";
    print("loadNewsByKey url = $url");
    Response response = await get(url);
    if (response.statusCode == 200) {
      LoadNewsResponse loadNewsResponse =
          LoadNewsResponse.fromJson(json.decode(response.body));
      return loadNewsResponse.articles;
    } else {
      throw Exception('Failed to load news ${response.statusCode}');
    }
  }
}

class _ApiUrls {
  static final String BASE_URL = "http://newsapi.org/";
  static final String END_POINT_EVETYTHING = "/v2/everything";
  static final String END_POINT_TOP_HEADLINES = "/v2/top-headlines";
}
