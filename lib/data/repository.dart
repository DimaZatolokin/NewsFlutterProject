import 'package:newsflutterprogect/data/database/database.dart';
import 'package:newsflutterprogect/data/models.dart';
import 'package:newsflutterprogect/data/network/network.dart';

abstract class Repository {
  Future<List<Article>> getTodayNewsByKeyWord(String kewWord);

  Future<List<Article>> getTodayEconomyNews();

  Future<List<Article>> getTodayEconomyNewsFromDB();

  saveTodayEconomyNewsToDB(List<Article> articles);
}

class RepositoryImpl implements Repository {
  NetworkDataSource _networkDataSource;
  DBProvider _dbProvider;

  RepositoryImpl(this._networkDataSource, this._dbProvider);

  @override
  Future<List<Article>> getTodayNewsByKeyWord(String kewWord) async {
    return _networkDataSource.loadNewsByKey(kewWord);
  }

  @override
  Future<List<Article>> getTodayEconomyNews() {
    return getTodayNewsByKeyWord(_NewsKeyWords.ECONOMY);
  }

  @override
  Future<List<Article>> getTodayEconomyNewsFromDB() {
    return _dbProvider.getAllArticles();
  }

  @override
  saveTodayEconomyNewsToDB(List<Article> articles) {
      _dbProvider.addArticles(articles);
  }
}

class _NewsKeyWords {
  static final String ECONOMY = "economy";
  static final String KHARKIV = "kharkiv";
}
