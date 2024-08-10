import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviehub/model/movie_detail_model.dart';
import 'package:moviehub/model/movie_model.dart';
import 'package:moviehub/model/now_playing_model.dart';
import 'package:moviehub/model/tv_series_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieService {
  static String bearer = dotenv.env['bearer'] ?? 'API URL not found';
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static Future<Map<String, dynamic>> searchMovies(
      String query, int page) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/search/movie?query=$query&page=$page&include_adult=false&language=en-US'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'movies': data['results'],
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<Map<String, dynamic>> fetchNowPlayingMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=$page'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'movies': data['results'],
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  static Future<Map<String, dynamic>> fetchPopularMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?language=en-US&page=$page'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'movies': data['results'],
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  static Future<Map<String, dynamic>> fetcTopratedMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=$page'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'movies': data['results'],
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  static Future<Map<String, dynamic>> fetcUpcomingMovies(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=$page'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'movies': data['results'],
        'total_pages': data['total_pages'],
      };
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  static Future<MovieDetail> fetchMovieDetail(int id) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/movie/$id?language=en-US'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return MovieDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch movie detail');
    }
  }

  static Future<TvSeriesDetail> fetchTvSeriesDetail(int id) async {
    final response = await http.get(
      Uri.parse('https://api.themoviedb.org/3/tv/$id?language=en-US'),
      headers: {
        'Authorization': 'Bearer $bearer',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return TvSeriesDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch TV series detail');
    }
  }

  static Future<String?> getYoutubeTrailerUrl(int movieId) async {
    final String url = '$baseUrl/movie/$movieId/videos';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $bearer',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        if (data.containsKey('results')) {
          final videos = data['results'] as List<dynamic>;

          // Cari video yang merupakan trailer YouTube
          final youtubeTrailer = videos.firstWhere(
            (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
            orElse: () => null,
          );

          if (youtubeTrailer != null) {
            final String videoKey = youtubeTrailer['key'];
            return 'https://www.youtube.com/watch?v=$videoKey';
          }
        }
      } else {
        throw Exception('Failed to load videos');
      }
    } catch (e) {
      print(e);
    }

    return null; // Tidak ada trailer YouTube yang ditemukan atau terjadi kesalahan
  }

  static Future<void> playYoutubeTrailer(
      BuildContext context, int movieId) async {
    String? youtubeUrl = await getYoutubeTrailerUrl(movieId);
    if (youtubeUrl != null) {
      if (await canLaunch(youtubeUrl)) {
        await launch(youtubeUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch $youtubeUrl')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trailer YouTube tidak ditemukan')));
    }
  }
}
