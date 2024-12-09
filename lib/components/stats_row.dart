import 'package:flutter/material.dart';
import 'package:spotify/theme/custom_color_scheme.dart';

class StatsRow extends StatelessWidget {
  final String followerCount;
  final String followingCount;
  final String playlistCount;

  const StatsRow({
    super.key,
    required this.followerCount,
    required this.followingCount,
    required this.playlistCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              followerCount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: customColorScheme.primary,
              ),
            ),
            Text(
              'followers'.toUpperCase(),
              style: TextStyle(
                color: customColorScheme.secondary,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              followingCount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: customColorScheme.primary,
              ),
            ),
            Text(
              'following'.toUpperCase(),
              style: TextStyle(
                color: customColorScheme.secondary,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              playlistCount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: customColorScheme.primary,
              ),
            ),
            Text(
              'playlists'.toUpperCase(),
              style: TextStyle(
                color: customColorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
