import 'package:newsflutterprogect/data/models.dart';
import 'package:newsflutterprogect/data/network/network.dart';

abstract class Repository {
  Future<List<Article>> getTodayNewsByKeyWord(String kewWord);

  Future<List<Article>> getTodayEconomyNews();
}

class RepositoryImpl implements Repository {
  NetworkDataSource _networkDataSource;

  RepositoryImpl(this._networkDataSource);

  @override
  Future<List<Article>> getTodayNewsByKeyWord(String kewWord) {
    return _networkDataSource.loadNewsByKey(kewWord);
  }

  @override
  Future<List<Article>> getTodayEconomyNews() {
    return getTodayNewsByKeyWord(_NewsKeyWords.ECONOMY);
  }
}

class _NewsKeyWords {
  static final String ECONOMY = "economy";
}
