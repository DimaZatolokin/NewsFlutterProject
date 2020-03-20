class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article(this.source, this.author, this.title, this.description, this.url,
      this.urlToImage, this.publishedAt, this.content);

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
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
  final String id;
  final String name;

  Source(this.id, this.name);

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(json['id'], json['name']);
  }
}
