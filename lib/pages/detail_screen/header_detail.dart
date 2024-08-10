import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moviehub/services/movie_service.dart';
import 'package:moviehub/utils/rating_row.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HeaderDetail extends StatefulWidget {
  const HeaderDetail({
    super.key,
    required this.title,
    required this.overview,
    required this.imageBanner,
    required this.releaseDate,
    required this.rating,
    required this.isMovie,
    required this.movieId,
  });

  final String title;
  final String overview;
  final String imageBanner;
  final double rating;
  final String releaseDate;
  final bool isMovie;
  final int movieId;

  @override
  State<HeaderDetail> createState() => _HeaderDetailState();
}

class _HeaderDetailState extends State<HeaderDetail> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.2),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final image = await screenshotController.capture();
              if (image != null) {
                final directory = await getApplicationDocumentsDirectory();
                final imagePath = File('${directory.path}/screenshot.png');
                await imagePath.writeAsBytes(image);

                Share.shareFiles([imagePath.path],
                    text: 'Check out this movie!');
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0.2),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    transitionOnUserGestures: true,
                    tag: 'movie-${widget.title}',
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: height / 1.5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500${widget.imageBanner}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AnimationLimiter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(seconds: 2),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.releaseDate}  \u2022 Adventure, Action \u2022',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Center(
                                child: MovieRating(voteAverage: widget.rating)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Text(
                                widget.overview,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2)),
                              child: GestureDetector(
                                onTap: () async {
                                  final image =
                                      await screenshotController.capture();
                                  if (image != null) {
                                    final directory =
                                        await getApplicationDocumentsDirectory();
                                    final imagePath = File(
                                        '${directory.path}/screenshot.png');
                                    await imagePath.writeAsBytes(image);

                                    Share.shareFiles([imagePath.path],
                                        text: 'Check out this movie!');
                                  }
                                },
                                child: const ShareWidget(),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2)),
                              child: GestureDetector(
                                onTap: () async {
                                  MovieService.playYoutubeTrailer(
                                      context, widget.movieId);
                                },
                                child: const PlayWidget(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShareWidget extends StatelessWidget {
  const ShareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Share",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.share,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayWidget extends StatelessWidget {
  const PlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Play Trailer",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
