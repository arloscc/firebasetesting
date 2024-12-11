class Book {
  final String id;
  final String title;
  final String author;
  final int year;

  Book({required this.id, required this.title, required this.author, required this.year});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'year': year,
      };

  static Book fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        author: json['author'],
        year: json['year'],
      );
}