// lib/models/movie_detail.dart
class MovieDetail {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final List<Genre> genres;

  MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.genres,
  });

  // Factory constructor to create MovieDetail from JSON
  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: json['vote_average'].toDouble(),
      genres: (json['genres'] as List<dynamic>)
          .map((genreJson) => Genre.fromJson(genreJson))
          .toList(),
    );
  }

  // Method to convert MovieDetail to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'genres': genres.map((genre) => genre.toJson()).toList(),
    };
  }
}

// lib/models/genre.dart
class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  // Factory constructor to create Genre from JSON
  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }

  // Method to convert Genre to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
