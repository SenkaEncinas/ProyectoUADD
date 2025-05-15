class PostDto {
  final int id;
  final String title;
  final double price; 
  final String author; 
  final String category;
  final String condition;
  final String location;
  final String paymentMethod;
  final String description;
  final String phoneNumber;
  final String email;
  final String whatsAppLink;
  final String imageUrl;
  final DateTime publishdate;

  PostDto({
    required this.id,
    required this.title,
    required this.price,
    required this.author,
    required this.category,
    required this.condition,
    required this.location,
    required this.paymentMethod,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.whatsAppLink,
    required this.imageUrl, 
    required this.publishdate,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) => PostDto(
        id: json['id'] as int,
        title: json['title'] as String,
        price: json['price'] as double,
        author: json['author'] as String,
        category: json['category'] as String,
        condition: json['condition'] as String,
        location: json['location'] as String,
        paymentMethod: json['paymentMethod'] as String,
        description: json['description'] as String,
        phoneNumber: json['phoneNumber'] as String,
        email: json['email'] as String,
        whatsAppLink: json['whatsAppLink'] as String,
        imageUrl: json['imageUrl'] as String,
        publishdate: json['publishdate'] as DateTime, 
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'author': author,
        'category': category,
        'condition': condition,
        'location': location,
        'paymentMethod': paymentMethod,
        'description': description,
        'phoneNumber': phoneNumber,
        'email': email,
        'whatsAppLink': whatsAppLink,
        'imageUrl': imageUrl,
        'publishdate' : publishdate,
      };
}