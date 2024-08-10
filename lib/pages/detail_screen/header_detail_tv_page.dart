import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moviehub/constant/color_constant.dart';
import 'package:moviehub/pages/detail_screen/header_detail.dart';
import 'package:moviehub/services/tv_service.dart';
import 'package:moviehub/utils/rating_row.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HeaderDetailTv extends StatefulWidget {
  const HeaderDetailTv({
    super.key,
    required this.title,
    required this.overview,
    required this.imageBanner,
    required this.releaseDate,
    required this.rating,
    required this.id,
  });

  final String title;
  final String overview;
  final String imageBanner;
  final double rating;
  final String releaseDate;
  final int id;

  @override
  State<HeaderDetailTv> createState() => _HeaderDetailTvState();
}

class _HeaderDetailTvState extends State<HeaderDetailTv> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.bgColors,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      backgroundColor: ColorConstant.bgColors,
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: height / 1.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                          0.5), // Warna bayangan dengan transparansi
                      spreadRadius: 5, // Radius penyebaran bayangan
                      blurRadius: 15, // Radius kekaburan bayangan
                      offset: const Offset(0,
                          4), // Posisi bayangan, offset horizontal dan vertikal
                    ),
                  ],
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${widget.imageBanner}',
                    ),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: height / 3,
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
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
                      MovieRating(voteAverage: widget.rating),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Text(
                          widget.overview,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5),
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
