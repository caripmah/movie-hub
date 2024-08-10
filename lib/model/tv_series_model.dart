// lib/models/tv_series_detail.dart
import 'package:moviehub/model/movie_detail_model.dart';

class TvSeriesDetail {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final List<Genre> genres;

  TvSeriesDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.genres,
  });

  // Factory constructor to create TvSeriesDetail from JSON
  factory TvSeriesDetail.fromJson(Map<String, dynamic> json) {
    return TvSeriesDetail(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: json['vote_average'].toDouble(),
      genres: (json['genres'] as List<dynamic>)
          .map((genreJson) => Genre.fromJson(genreJson))
          .toList(),
    );
  }

  // Method to convert TvSeriesDetail to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'genres': genres.map((genre) => genre.toJson()).toList(),
    };
  }
}
