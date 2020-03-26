class ArticleDB {
  int id;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;
  String sourceId;

  ArticleDB(this.id, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content, this.sourceId);

  factory ArticleDB.fromJson(Map<String, dynamic> json) {
    return ArticleDB(
        json['id'] != null ? json['id'] : null,
        json['author'] == null ? "" : json['author'],
        json['title'] == null ? "" : json['title'],
        json['description'] == null ? "" : json['description'],
        json['url'],
        json['urlToImage'] == null ? "" : json['urlToImage'],
        json['publishedAt'] == null ? "" : json['publishedAt'],
        json['content'] == null ? "" : json['content'],
        json['sourceId'] == null ? null : json['sourceId']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt,
        "content": content,
        "sourceId": sourceId
      };
}

class SourceDB {
  String id;
  final String name;

  SourceDB(this.id, this.name);

  factory SourceDB.fromJson(Map<String, dynamic> json) {
    return SourceDB(json['id'] != null ? json['id'] : null,
        json['name'] != null ? json['name'] : "");
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
