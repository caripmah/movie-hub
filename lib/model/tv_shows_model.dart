class TvShowsModel {
  final String name;
  final String backdropPath;
  final String posterPath;
  final String overview;
  final String firstAirDate;

  TvShowsModel(
      {required this.name,
      required this.backdropPath,
      required this.posterPath,
      required this.overview,
      required this.firstAirDate});

  factory TvShowsModel.fromJson(dynamic json) => TvShowsModel(
      name: json['name'],
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      firstAirDate: json['first_air_date']);
}