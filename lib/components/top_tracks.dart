import 'package:flutter/material.dart';
import 'package:spotify/screens/track_details_page.dart';
import 'package:spotify/theme/custom_color_scheme.dart';

class TopTracks extends StatelessWidget {
  final List<dynamic>? topTracks;

  const TopTracks({super.key, required this.topTracks});

  @override
  Widget build(BuildContext context) {
    if (topTracks == null || topTracks!.isEmpty) {
      return Center(child: Text('No top tracks available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Tracks of All Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customColorScheme.primary,
                foregroundColor: customColorScheme.onPrimary,
              ),
              onPressed: () {
                // Navigate to the full list of tracks
                print('See More Tracks');
              },
              child: Text('SEE MORE'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: topTracks!.map((track) {
            return GestureDetector(
              onTap: () {
                // Navigate to TrackDetailsPage with the track ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrackDetailsPage(
                      trackId: track['id'], // Pass the track ID
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.network(
                      track['album']['images'][0]['url'],
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track['name'],
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            track['artists']
                                .map((artist) => artist['name'])
                                .join(', '),
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      '${(track['duration_ms'] / 60000).floor()}:${((track['duration_ms'] / 1000) % 60).toStringAsFixed(0).padLeft(2, '0')}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
