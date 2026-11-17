class NewsModel {
  String? status;
  int? totalResults;
  List<Articles> articles;

  NewsModel({this.status, this.totalResults, List<Articles>? articles})
    : articles = articles ?? [];

  factory NewsModel.fromJson(Map<dynamic, dynamic> json) {
    final rawArticles = json['articles'];
    return NewsModel(
      status: json['status'] as String?,
      totalResults: json['totalResults'] as int?,
      articles: rawArticles is List
          ? rawArticles
                .whereType<Map<dynamic, dynamic>>()
                .map(Articles.fromJson)
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'totalResults': totalResults,
    'articles': articles.map((v) => v.toJson()).toList(),
  };
}

class Articles {
  Source? source;
  String? author;
  String title;
  String? description;
  String url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Articles({
    this.source,
    this.author,
    this.title = '',
    this.description,
    this.url = '',
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory Articles.fromJson(Map<dynamic, dynamic> json) {
    final rawSource = json['source'];
    return Articles(
      source: rawSource is Map ? Source.fromJson(rawSource) : null,
      author: json['author'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] as String?,
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (source != null) 'source': source!.toJson(),
    'author': author,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt,
    'content': content,
  };

  /// Data saved on the device when an article is liked.
  Map<String, dynamic> toFavoriteJson() => {
    'url': url,
    'urlToImage': urlToImage,
    'title': title,
    'author': author,
    'publishedAt': publishedAt,
    'source': source?.toJson(),
  };
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<dynamic, dynamic> json) =>
      Source(id: json['id'] as String?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
