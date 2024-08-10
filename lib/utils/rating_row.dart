import 'package:flutter/material.dart';
import 'package:moviehub/utils/rating_widget.dart';

class MovieRating extends StatelessWidget {
  final double voteAverage;

  MovieRating({required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    // Konversi voteAverage dari skala 10 ke skala 5
    double ratingIn5Scale = (voteAverage / 10) * 5;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$voteAverage',
          style: TextStyle(color: Colors.yellow, fontSize: 18),
        ),
        SizedBox(width: 5),
        RatingWidget(
          rating: ratingIn5Scale,
          starSize: 15.0,
        ),
      ],
    );
  }
}
