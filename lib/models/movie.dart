class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final int? year;
  final List<String> genres;

  Movie({required this.id, required this.title, required this.posterUrl, required this.overview, this.year, this.genres = const []});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      overview: json['overview'] ?? '',
      year: json['year'] is int ? json['year'] as int : int.tryParse(json['year']?.toString() ?? ''),
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}
