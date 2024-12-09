import 'package:flutter/material.dart';
import 'package:spotify/services/spotify_service.dart';
import 'package:spotify/theme/custom_color_scheme.dart';
import 'package:spotify/screens/track_details_page.dart';

class AlbumDetailsPage extends StatefulWidget {
  final String albumId;

  const AlbumDetailsPage({
    super.key,
    required this.albumId,
  });

  @override
  _AlbumDetailsPageState createState() => _AlbumDetailsPageState();
}

class _AlbumDetailsPageState extends State<AlbumDetailsPage> {
  Map<String, dynamic>? albumDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbumDetails();
  }

  Future<void> _fetchAlbumDetails() async {
    try {
      final fetchedDetails =
          await SpotifyService.fetchAlbumDetails(widget.albumId);

      setState(() {
        albumDetails = fetchedDetails;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Failed to fetch album details.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String formatDuration(int durationMs) {
    final duration = Duration(milliseconds: durationMs);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : albumDetails == null
                ? Center(child: Text('No details available.'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Album Artwork
                        Center(
                          child: Image.network(
                            albumDetails!['images'][0]['url'],
                            width: 300,
                            height: 300,
                          ),
                        ),
                        SizedBox(height: 32),
                        // Album Name
                        Text(
                          albumDetails!['name'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Artist Name
                        Text(
                          'By ${albumDetails!['artists'][0]['name']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        // Release Date
                        Text(
                          'Released on ${albumDetails!['release_date']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        // Tracks List
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: albumDetails!['tracks']['items'].length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              thickness: 1,
                              color: customColorScheme.secondary,
                            );
                          },
                          itemBuilder: (context, index) {
                            final track =
                                albumDetails!['tracks']['items'][index];
                            final trackNumber = track['track_number'];
                            final trackName = track['name'];
                            final duration =
                                formatDuration(track['duration_ms']);
                            final trackId = track['id']; // Get track ID

                            return ListTile(
                              leading: Text(
                                trackNumber.toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: customColorScheme.secondary),
                              ),
                              title: Text(
                                trackName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: customColorScheme.onPrimary,
                                ),
                              ),
                              trailing: Text(
                                duration,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: customColorScheme.secondary),
                              ),
                              onTap: () {
                                // Navigate to TrackDetailsPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TrackDetailsPage(
                                      trackId: trackId,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
