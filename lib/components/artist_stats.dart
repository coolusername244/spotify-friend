import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArtistStats extends StatelessWidget {
  final int followers;
  final List<dynamic> genres;
  final int popularity;

  const ArtistStats({
    super.key,
    required this.followers,
    required this.genres,
    required this.popularity,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormatter = NumberFormat.decimalPattern();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Followers: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: numberFormatter.format(followers),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Genres: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: genres.join(', '),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Popularity: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '$popularity%',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
