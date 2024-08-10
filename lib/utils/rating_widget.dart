import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double maxRating;
  final int starCount;
  final Color filledStarColor;
  final Color unfilledStarColor;
  final double starSize;

  RatingWidget({
    required this.rating,
    this.maxRating = 5.0,
    this.starCount = 5,
    this.filledStarColor = Colors.amber,
    this.unfilledStarColor = Colors.grey,
    this.starSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    int filledStars = (rating / maxRating * starCount).floor();
    double partialStar = (rating / maxRating * starCount) - filledStars;

    for (int i = 0; i < starCount; i++) {
      if (i < filledStars) {
        stars.add(Icon(
          Icons.star,
          color: filledStarColor,
          size: starSize,
        ));
      } else if (i == filledStars && partialStar > 0) {
        stars.add(Icon(
          Icons.star_half,
          color: filledStarColor,
          size: starSize,
        ));
      } else {
        stars.add(Icon(
          Icons.star_border,
          color: unfilledStarColor,
          size: starSize,
        ));
      }
    }

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: stars);
  }
}
