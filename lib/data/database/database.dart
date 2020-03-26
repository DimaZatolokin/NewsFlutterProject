import 'dart:io';
import 'dart:math';

import 'package:newsflutterprogect/data/database/models_db.dart';
import 'package:newsflutterprogect/data/mappers.dart';
import 'package:newsflutterprogect/data/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DBProvider {
  DBProvider._() {
    print("DBProvider init()");
  }

  static final DBProvider dbProvider = DBProvider._();
  Database _database;
  SourceMapper sourceMapper = SourceMapper();
  ArticleMapper articleMapper = ArticleMapper();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "NewsDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      String articleSql = "CREATE TABLE ${_ArticlesTable.KEY_TABLE_NAME}("
          "${_ArticlesTable.KEY_ID} INTEGER PRIMARY KEY AUTOINCREMENT,"
          "${_ArticlesTable.KEY_AUTHOR} TEXT,"
          "${_ArticlesTable.KEY_TITLE} TEXT UNIQUE,"
          "${_ArticlesTable.KEY_DESCRIPTION} TEXT,"
          "${_ArticlesTable.KEY_URL} TEXT,"
          "${_ArticlesTable.KEY_URL_TO_IMAGE} TEXT,"
          "${_ArticlesTable.KEY_URL_DATE} TEXT,"
          "${_ArticlesTable.KEY_URL_CONTENT} TEXT,"
          "${_ArticlesTable.KEY_SOURCE_ID} TEXT"
          ")";
      print(articleSql);
      String sourceSql = "CREATE TABLE ${_SourcesTable.KEY_TABLE_NAME}("
          "${_SourcesTable.KEY_ID} TEXT PRIMARY KEY,"
          "${_SourcesTable.KEY_NAME} TEXT"
          ")";
      print(sourceSql);
      await db.execute(articleSql);
      await db.execute(sourceSql);
    });
  }

  addArticle(Article article) async {
    final db = await database;
    var res = await db.insert(_ArticlesTable.KEY_TABLE_NAME,
        articleMapper.mapToDBLayer(article).toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  addArticles(List<Article> articles) async {
    final db = await database;
    Batch batch = db.batch();
    articles.forEach((article) {
      batch.insert(_ArticlesTable.KEY_TABLE_NAME,
          articleMapper.mapToDBLayer(article).toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      saveSource(article.source);
    });
    batch.commit(noResult: true, continueOnError: true);
  }

  Future<List<Article>> getAllArticles() async {
    final db = await database;
    var res = await db.query(_ArticlesTable.KEY_TABLE_NAME);
    List<ArticleDB> articlesDB = res.isNotEmpty
        ? res.map((e) => ArticleDB.fromJson(e)).toList()
        : List();
    List<Article> articles = List<Article>();
    for (var articleDB in articlesDB) {
      SourceDB sourceDB = await getSourceById(articleDB.sourceId);
      Article article = articleMapper.mapFromDBLayer(articleDB);
      article.source = sourceMapper.mapFromDBLayer(sourceDB);
      print("sourceDB.name = ${sourceDB == null ? "nullll" : sourceDB.name}");
      articles.add(article);
    }
    return articles;
  }

  deleteAllArticles() async {
    final db = await database;
    String sql = "DELETE * FROM ${_ArticlesTable.KEY_TABLE_NAME}";
    print(sql);
    db.rawDelete(sql);
  }

  Future<SourceDB> getSourceById(String sourceId) async {
    final db = await database;
    var res = await db.query(_SourcesTable.KEY_TABLE_NAME,
        where: "id=?", whereArgs: [sourceId]);
    print("sourceId = ${sourceId}");
    print("res.isNotEmpty = ${res.isNotEmpty}");
    print("(res.first = ${res.isNotEmpty ? res.first : "EMPTY"}");
    return res.isNotEmpty ? SourceDB.fromJson(res.first) : null;
  }

  saveSource(Source source) async {
    final db = await database;
    if (source.id == null) {
      String newId = Uuid().v1();
      source.id = newId;
    }
    db.insert(_SourcesTable.KEY_TABLE_NAME,
        sourceMapper.mapToDBLayer(source).toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

class _ArticlesTable {
  static final String KEY_TABLE_NAME = "Articles";
  static final String KEY_ID = "id";
  static final String KEY_AUTHOR = "author";
  static final String KEY_TITLE = "title";
  static final String KEY_DESCRIPTION = "description";
  static final String KEY_URL = "url";
  static final String KEY_URL_TO_IMAGE = "urlToImage";
  static final String KEY_URL_DATE = "publishedAt";
  static final String KEY_URL_CONTENT = "content";
  static final String KEY_SOURCE_ID = "sourceId";
}

class _SourcesTable {
  static final String KEY_TABLE_NAME = "Sources";
  static final String KEY_ID = "id";
  static final String KEY_NAME = "name";
}
