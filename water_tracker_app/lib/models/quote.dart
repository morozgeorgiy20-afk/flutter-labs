class Quote {
  final String text;
  final String author;
  final String category;

  Quote({
    required this.text,
    required this.author,
    required this.category,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['q'] ?? 'Drink water to stay healthy!',
      author: json['a'] ?? 'Unknown',
      category: json['c'] ?? 'health',
    );
  }

  factory Quote.empty() {
    return Quote(
      text: 'Stay hydrated for better health and energy!',
      author: 'Water Tracker',
      category: 'health',
    );
  }
}