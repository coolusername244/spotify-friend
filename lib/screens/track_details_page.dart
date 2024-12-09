import 'package:flutter/material.dart';
import 'package:spotify/services/spotify_service.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackDetailsPage extends StatefulWidget {
  final String trackId;

  const TrackDetailsPage({
    super.key,
    required this.trackId,
  });

  @override
  _TrackDetailsPageState createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> {
  Map<String, dynamic>? trackDetails;
  Map<String, dynamic>? trackAnalysis;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTrackDetails();
  }

  Future<void> _fetchTrackDetails() async {
    try {
      final fetchedTrackDetails =
          await SpotifyService.fetchTrackDetails(widget.trackId);
      final fetchedTrackAnalysis =
          await SpotifyService.fetchTrackAnalysis(widget.trackId);

      setState(() {
        trackDetails = fetchedTrackDetails;
        trackAnalysis = fetchedTrackAnalysis;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError('Failed to fetch track details');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : trackDetails == null
                  ? Center(child: Text('No details available'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            Image.network(
                              trackDetails!['album']['images'][0]['url'],
                              height: 350, // Set the height for better display
                              width: 350, // Make it responsive
                              fit: BoxFit
                                  .cover, // Adjust the fit to cover the area
                            ),
                            SizedBox(height: 12),
                            Text(
                              trackDetails!['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              trackDetails!['artists']
                                  .map((artist) => artist['name'])
                                  .join(', '),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(height: 12),
                            Text(
                              trackDetails!['album']['name'],
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12),
                            Text(trackDetails!['album']['release_date']),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final url = Uri.parse(
                                          trackDetails!['album']
                                              ['external_urls']['spotify']);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        print('Could not launch $url');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Could not open Spotify link.',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'View Album'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final url = Uri.parse(
                                          trackDetails!['external_urls']
                                              ['spotify']);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        print('Could not launch $url');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Could not open Spotify link.'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Play on Spotify'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
    );
  }
}
