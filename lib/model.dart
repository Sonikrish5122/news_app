class NewsQueryModel {
  String title;
  String description;
  String content;
  String imageUrl;
  String articleUrl;

  NewsQueryModel({
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.articleUrl,
  });

  factory NewsQueryModel.fromMap(Map<String, dynamic> json) {
    return NewsQueryModel(
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      content: json['content'] ?? "",
      imageUrl: json['urlToImage'] ?? "",
      articleUrl: json['url'] ?? "",
    );
  }
}
