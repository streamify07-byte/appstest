class Episode {
  final int episodeNumber;
  final String title;
  final int? durationMinutes;

  Episode({required this.episodeNumber, required this.title, this.durationMinutes});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      episodeNumber: json['episodeNumber'] is int ? json['episodeNumber'] as int : int.tryParse(json['episodeNumber']?.toString() ?? '') ?? 0,
      title: json['title'] ?? '',
      durationMinutes: json['duration'] is int ? json['duration'] as int : int.tryParse(json['duration']?.toString() ?? ''),
    );
  }
}

class Season {
  final int seasonNumber;
  final List<Episode> episodes;

  Season({required this.seasonNumber, required this.episodes});

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      seasonNumber: json['seasonNumber'] is int ? json['seasonNumber'] as int : int.tryParse(json['seasonNumber']?.toString() ?? '') ?? 0,
      episodes: (json['episodes'] as List<dynamic>? ?? [])
          .map((e) => Episode.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}

class Series {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<Season> seasons;

  Series({required this.id, required this.title, required this.posterUrl, required this.overview, required this.seasons});

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      overview: json['overview'] ?? '',
      seasons: (json['seasons'] as List<dynamic>? ?? [])
          .map((s) => Season.fromJson(Map<String, dynamic>.from(s as Map)))
          .toList(),
    );
  }
}
