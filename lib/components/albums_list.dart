import 'package:flutter/material.dart';
import 'package:spotify/screens/album_track_list_page.dart';

class AlbumsList extends StatelessWidget {
  final List<dynamic>? albums;

  const AlbumsList({
    super.key,
    required this.albums,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Set a fixed height for the list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums?.length ?? 0,
        itemBuilder: (context, index) {
          final album = albums![index];
          return GestureDetector(
            onTap: () {
              // Navigate to the AlbumTrackListPage and pass the album ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumDetailsPage(
                    albumId: album['id'], // Pass album ID
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      album['images'][0]['url'], // Album image
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 150,
                    child: Text(
                      album['name'], // Album name
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
