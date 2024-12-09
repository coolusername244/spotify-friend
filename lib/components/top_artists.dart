import 'package:flutter/material.dart';
import 'package:spotify/screens/artist_details_page.dart';
import 'package:spotify/theme/custom_color_scheme.dart';

class TopArtists extends StatelessWidget {
  final List<dynamic>? topArtists;

  const TopArtists({super.key, required this.topArtists});

  @override
  Widget build(BuildContext context) {
    if (topArtists == null || topArtists!.isEmpty) {
      return Center(child: Text('No top artists available.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Artists of All Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customColorScheme.primary,
                foregroundColor: customColorScheme.onPrimary,
              ),
              onPressed: () {
                // Navigate to a more detailed artist list page (if needed)
                print('See More Artists');
              },
              child: Text('SEE MORE'),
            ),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: topArtists!.map((artist) {
            return InkWell(
              onTap: () {
                // Navigate to ArtistDetailPage with artist.id
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ArtistDetailsPage(artistId: artist!['id']),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(artist['images'][0]['url']),
                      radius: 40,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        artist['name'],
                        style: TextStyle(fontSize: 16),
                      ),
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
