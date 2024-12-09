import 'package:flutter/material.dart';
import '../services/spotify_service.dart';
import '../components/profile_header.dart';
import '../components/stats_row.dart';
import '../components/logout_button.dart';
import '../components/top_artists.dart';
import '../components/top_tracks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userProfile;
  List<dynamic>? topArtists;
  List<dynamic>? topTracks;
  int? following;
  int? playlist;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final profile = await SpotifyService.fetchUserProfile();
      final artists = await SpotifyService.fetchTopArtists();
      final tracks = await SpotifyService.fetchTopTracks();
      final followingData = await SpotifyService.fetchFollowingData();
      final playlistData =
          await SpotifyService.fetchPlaylistCount(profile!['id']);

      setState(() {
        userProfile = profile;
        topArtists = artists;
        topTracks = tracks;
        following = followingData;
        playlist = playlistData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('An error occurred: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userProfile == null) {
      return Scaffold(
        body: Center(child: Text('Failed to load profile data.')),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                imageUrl: (userProfile!['images'] as List?)?.isNotEmpty == true
                    ? userProfile!['images'][0]['url']
                    : null,
                displayName: userProfile!['display_name'] ?? 'Unknown User',
                accountType: userProfile!['product'] ?? 'Unknown',
              ),
              SizedBox(height: 32),
              StatsRow(
                followerCount: userProfile!['followers']['total'].toString(),
                followingCount: following.toString(),
                playlistCount: playlist.toString(),
              ),
              SizedBox(height: 32),
              LogoutButton(),
              SizedBox(height: 32),
              TopArtists(topArtists: topArtists),
              SizedBox(height: 32),
              TopTracks(topTracks: topTracks),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
