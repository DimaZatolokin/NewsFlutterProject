class Article {
  int id;
  Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article(this.id, this.source, this.author, this.title, this.description,
      this.url, this.urlToImage, this.publishedAt, this.content);

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        json['id'] != null ? json['id'] : null,
        Source.fromJson(json['source']),
        json['author'] == null ? "" : json['author'],
        json['title'] == null ? "" : json['title'],
        json['description'] == null ? "" : json['description'],
        json['url'],
        json['urlToImage'] == null ? "" : json['urlToImage'],
        json['publishedAt'] == null ? "" : json['publishedAt'],
        json['content'] == null ? "" : json['content']);
  }
}

class Source {
  String id;
  final String name;

  Source(this.id, this.name);

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(json['id'] != null ? json['id'] : "",
        json['name'] != null ? json['name'] : "");
  }
}
