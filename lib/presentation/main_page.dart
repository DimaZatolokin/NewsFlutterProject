import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newsflutterprogect/data/database/database.dart';
import 'package:newsflutterprogect/data/models.dart';
import 'package:newsflutterprogect/data/network/network.dart';
import 'package:newsflutterprogect/data/repository.dart';
import 'package:newsflutterprogect/presentation/utils.dart';

class MainPage extends StatefulWidget {
  List<Article> _articles;

  _updateArticles(List<Article> items) {
    _articles = items;
  }

  MainPage() {
    print("MainPage()");
  }

  @override
  State<StatefulWidget> createState() {
    return MainState(_articles, _updateArticles);
  }
}

class MainState extends State<MainPage> {
  Future<List<Article>> news;
  List<Article> items;
  bool _loading = false;
  GlobalKey<MainState> _refreshKey = GlobalKey<MainState>();
  Function(List<Article> items) _updateParentItems;

  MainState(List<Article> articles, this._updateParentItems) {
    items = articles;
  }

  void updateItems(List<Article> articles) {
    setState(() {
      items = articles;
      _updateParentItems.call(articles);
    });
  }

  @override
  void initState() {
    super.initState();
    print("initState()");
    if (items == null || items.isEmpty) {
      _loadNews();
    }
  }

  Future<void> _loadNews() {
    _loading = true;
    var repository = RepositoryImpl(
        NetworkDataSourceImpl(FlutterSecureStorage()), DBProvider.dbProvider);
    return repository
        .getTodayEconomyNews()
        .then((value) => {
              _loading = false,
              updateItems(value),
              print("items count = ${value.length}"),
              repository.saveTodayEconomyNewsToDB(value)
            })
        .catchError((e) {
      _loading = false;
      updateItems([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("buiiiiiild");
    return RefreshIndicator(
      key: _refreshKey,
      child: getMainWidget(),
      onRefresh: _loadNews,
    );
  }

  Widget getMainWidget() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    } else if (items == null || items.isEmpty) {
      return Center(
        child: Text("No news"),
      );
    } else {
      return ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          });
    }
  }

  Widget getRow(int position) {
    var item = items[position];
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            border: Border(
                top: BorderSide(),
                left: BorderSide(),
                bottom: BorderSide(),
                right: BorderSide())),
        margin: EdgeInsets.all(10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 1,
            child: Column(children: [
              getImageWidget(item),
              getAuthorWidget(item),
              getSourceWidget(item)
            ]),
          ),
          Expanded(
              flex: 4,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: getTitleWidget(item),
                      ),
                      Expanded(
                        flex: 1,
                        child: getDateWidget(item),
                      )
                    ],
                  ),
                  Center(
                    child: getDescriptionWidget(item),
                  )
                ],
              )),
        ]));
  }

  Text getDescriptionWidget(Article item) =>
      Text(item.description, style: TextStyle(fontSize: 11));

  Text getDateWidget(Article item) {
    return Text(
      DateTimeUtils.getReadableDate(item.publishedAt),
      style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
    );
  }

  Text getTitleWidget(Article item) {
    return Text(item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold));
  }

  Positioned getAuthorWidget(Article item) {
    return new Positioned(
        bottom: 0,
        child: new Align(
          alignment: FractionalOffset.bottomCenter,
          child: Text(
            item.author == null ? "" : item.author,
            style: TextStyle(fontSize: 12),
            maxLines: 1,
          ),
        ));
  }

  Text getSourceWidget(Article item) {
    return Text(
      item.source != null ? item.source.name : "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 12),
    );
  }

  Image getImageWidget(Article item) {
    return Image.network(
      item.urlToImage,
    );
  }
}
