import 'package:flutter/material.dart';
import 'package:spotify/components/albums_list.dart';
import 'package:spotify/components/artist_header.dart';
import 'package:spotify/components/artist_stats.dart';
import 'package:spotify/components/artist_top_tracks.dart';
import 'package:spotify/services/spotify_service.dart';

class ArtistDetailsPage extends StatefulWidget {
  final String artistId;

  const ArtistDetailsPage({super.key, required this.artistId});

  @override
  _ArtistDetailsPageState createState() => _ArtistDetailsPageState();
}

class _ArtistDetailsPageState extends State<ArtistDetailsPage> {
  Map<String, dynamic>? artistDetails;
  List<dynamic>? artistDiscography;
  List<dynamic>? artistTopTracks;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArtistDetails();
  }

  Future<void> _fetchArtistDetails() async {
    try {
      final fetchedDetails =
          await SpotifyService.fetchArtistDetails(widget.artistId);
      final discographyDetails =
          await SpotifyService.fetchArtistDiscography(widget.artistId);
      final topTracksDetails =
          await SpotifyService.fetchArtistTopTracks(widget.artistId);

      setState(() {
        artistDetails = fetchedDetails;
        artistDiscography = discographyDetails;
        artistTopTracks = topTracksDetails;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Failed to fetch artist details.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : artistDetails == null
                ? Center(child: Text('No details available.'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ArtistHeader(
                          imageUrl: artistDetails!['images'][0]['url'],
                          name: artistDetails!['name'],
                        ),
                        SizedBox(height: 32),
                        ArtistStats(
                          followers: artistDetails!['followers']['total'],
                          genres: artistDetails!['genres'],
                          popularity: artistDetails!['popularity'],
                        ),
                        SizedBox(height: 32),
                        ArtistTopTracks(
                          topTracks: artistTopTracks,
                          // artistName: artistDetails!['name'] ?? '',
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Albums:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        AlbumsList(albums: artistDiscography),
                      ],
                    ),
                  ),
      ),
    );
  }
}
