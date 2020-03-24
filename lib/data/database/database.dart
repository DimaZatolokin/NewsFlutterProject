import 'dart:io';
import 'dart:math';

import 'package:newsflutterprogect/data/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._() {
    print("DBProvider init()");
  }

  static final DBProvider dbProvider = DBProvider._();
  Database _database;

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
      String sql = "CREATE TABLE ${_ArticlesTable.KEY_TABLE_NAME}("
          "${_ArticlesTable.KEY_ID} INTEGER PRIMARY KEY,"
          "${_ArticlesTable.KEY_AUTHOR} TEXT,"
          "${_ArticlesTable.KEY_TITLE} TEXT UNIQUE,"
          "${_ArticlesTable.KEY_DESCRIPTION} TEXT,"
          "${_ArticlesTable.KEY_URL} TEXT,"
          "${_ArticlesTable.KEY_URL_TO_IMAGE} TEXT,"
          "${_ArticlesTable.KEY_URL_DATE} TEXT,"
          "${_ArticlesTable.KEY_URL_CONTENT} TEXT"
          ")";
      print(sql);
      await db.execute(sql);
    });
  }

  addArticle(Article article) async {
    final db = await database;
    var res = await db.insert(_ArticlesTable.KEY_TABLE_NAME, article.toJson());
    return res;
  }

  addArticles(List<Article> articles) async {
    final db = await database;
    Batch batch = db.batch();
    articles.forEach((article) {
      batch.insert(_ArticlesTable.KEY_TABLE_NAME, article.toJson());
    });
    batch.commit(noResult: true);
  }

  Future<List<Article>> getAllArticles() async {
    final db = await database;
    var res = await db.query(_ArticlesTable.KEY_TABLE_NAME);
    List<Article> articles =
        res.isNotEmpty ? res.map((e) => Article.fromJson(e)).toList() : List();
    return articles;
  }

  deleteAllArticles() async {
    final db = await database;
    String sql = "DELETE * FROM ${_ArticlesTable.KEY_TABLE_NAME}";
    print(sql);
    db.rawDelete(sql);
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
}
