class MovieModel {
  final String title;
  final String backdropPath;
  final String posterPath;
  final String overview;
  final String releaseDate;

  MovieModel(
      {required this.title,
      required this.backdropPath,
      required this.posterPath,
      required this.overview,
      required this.releaseDate});

  factory MovieModel.fromJson(dynamic json) => MovieModel(
      title: json['title'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      releaseDate: json['release_date']);
}
