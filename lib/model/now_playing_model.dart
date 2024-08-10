class NowPlayingResponse {
  final int page;
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  NowPlayingResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory NowPlayingResponse.fromJson(Map<String, dynamic> json) {
    return NowPlayingResponse(
      page: json['page'],
      results: (json['results'] as List)
          .map((movieJson) => Movie.fromJson(movieJson))
          .toList(),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

class Movie {
  final String title;
  final String posterPath;
  final String releaseDate;

  Movie({
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
    );
  }
}
