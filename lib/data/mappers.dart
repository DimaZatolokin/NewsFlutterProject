import 'package:newsflutterprogect/data/database/models_db.dart';
import 'package:newsflutterprogect/data/models.dart';

abstract class BaseMapper<DOMAIN_TYPE, DB_TYPE> {
  DB_TYPE mapToDBLayer(DOMAIN_TYPE object);

  DOMAIN_TYPE mapFromDBLayer(DB_TYPE object);
}

class ArticleMapper implements BaseMapper<Article, ArticleDB> {
  @override
  Article mapFromDBLayer(ArticleDB object) {
    return Article(
        object.id,
        null,
        object.author,
        object.title,
        object.description,
        object.url,
        object.urlToImage,
        object.publishedAt,
        object.content);
  }

  @override
  ArticleDB mapToDBLayer(Article object) {
    return ArticleDB(
        object.id,
        object.author,
        object.title,
        object.description,
        object.url,
        object.urlToImage,
        object.publishedAt,
        object.content,
        object.source.id);
  }
}

class SourceMapper implements BaseMapper<Source, SourceDB> {
  @override
  Source mapFromDBLayer(SourceDB object) {
    return object == null ? null : Source(object.id, object.name);
  }

  @override
  SourceDB mapToDBLayer(Source object) {
    return SourceDB(object.id, object.name);
  }
}
