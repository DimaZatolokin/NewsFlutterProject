import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newsflutterprogect/data/database/database.dart';
import 'package:newsflutterprogect/data/models.dart';
import 'package:newsflutterprogect/data/network/network.dart';
import 'package:newsflutterprogect/data/repository.dart';
import 'package:newsflutterprogect/presentation/utils.dart';

class AdditionalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AdditionalState();
}

class AdditionalState extends State<AdditionalPage> {
  Future<List<Article>> news;
  List<Article> items;
  bool _loading;

  void updateItems(List<Article> articles) {
    setState(() {
      items = articles;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    _loading = true;
    RepositoryImpl(NetworkDataSourceImpl(FlutterSecureStorage()),
            DBProvider.dbProvider)
        .getTodayEconomyNewsFromDB()
        .then((value) => {
              _loading = false,
              updateItems(value),
              print("DB items count = ${value.length}")
            })
        .catchError((e) {
      _loading = false;
      updateItems([]);
    });
  }

  @override
  Widget build(BuildContext context) {
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
