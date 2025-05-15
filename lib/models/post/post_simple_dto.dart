class PostSimpleDto {
  final int id;
  final String title;
  final double price;
  final String author;
  final String category;

  PostSimpleDto({
    required this.id,
    required this.title,
    required this.price,
    required this.author,
    required this.category,
  });

  factory PostSimpleDto.fromJson(Map<String, dynamic> json) => PostSimpleDto(
        id: json['id'] as int,
        title: json['title'] as String,
        price: json['price'] as double,
        author: json['author'] as String,
        category: json['category'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id' : id,
        'title': title,
        'price': price,
        'author': author,
        'category': category,
      };
}