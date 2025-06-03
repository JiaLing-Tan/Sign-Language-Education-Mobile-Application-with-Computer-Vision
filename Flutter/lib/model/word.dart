class Word {
  final int id;
  final String my;
  final String eng;
  final String link;

  Word({
    required this.id,
    required this.my,
    required this.eng,
    required this.link,
  });

  // Convert from JSON (Supabase response)
  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as int,
      my: json['my'] as String,
      eng: json['eng'] as String,
      link: json['link'] as String,
    );
  }

  Word copyWith({
    int? id,
  String? my,
    String? eng,
    String? link,
  }) {
    return Word(
      id: id ?? this.id,
      my: my ?? this.my,
      eng: eng ?? this.eng,
      link: link ?? this.link,
    );
  }
}