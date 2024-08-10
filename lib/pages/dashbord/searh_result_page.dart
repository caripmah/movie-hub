// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/constant/color_constant.dart';
import 'package:moviehub/controller/dahboard_controller.dart';
import 'package:moviehub/routes/app_routesname.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;
  const SearchResultsPage({super.key, required this.query});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final MovieController movieController = Get.find<MovieController>();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        movieController.loadMoreMovies(widget.query);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: ColorConstant.bgColors,
        title: Text(
          'Search Results for "${widget.query}"',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: ColorConstant.bgColors,
      body: Obx(() {
        if (movieController.isLoading.value &&
            movieController.movieList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (movieController.movieList.isEmpty) {
          return const Center(
            child:
                Text('No results found', style: TextStyle(color: Colors.white)),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: movieController.movieList.length +
              1, // Add one for loading indicator
          itemBuilder: (context, index) {
            if (index == movieController.movieList.length) {
              // Display loading indicator at the end of the list
              return movieController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox();
            }

            final movie = movieController.movieList[index];
            return ListTile(
              leading: movie['poster_path'] != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w200${movie['poster_path']}')
                  : null,
              title:
                  Text(movie['title'], style: TextStyle(color: Colors.white)),
              subtitle: Text(movie['release_date'] ?? 'Unknown',
                  style: TextStyle(color: Colors.white70)),
              onTap: () {
                Random random = Random();
                int min = 7;
                int max = 10;

                int randomValue = min + random.nextInt(max - min);

                Get.toNamed(
                  AppRoutesname.detailScreen,
                  arguments: {
                    'title': movie['original_title'],
                    'overview': movie['overview'],
                    'imageBanner': movie['backdrop_path'],
                    'releaseDate': movie['release_date'],
                    'rating': randomValue,
                    'isMovie': true,
                    'movieId': movie['id'],
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
