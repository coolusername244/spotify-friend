import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'auth_service.dart';

class SpotifyService {
  static final String clientId = dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  static final String clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';
  static final String redirectUri = dotenv.env['REDIRECT_URI'] ?? '';
  static final String authEndpoint = dotenv.env['SPOTIFY_AUTH_URL'] ?? '';
  static final String tokenEndpoint = dotenv.env['SPOTIFY_TOKEN_URL'] ?? '';
  static final String accountUrl = dotenv.env['SPOTIFY_ACCOUNT_URL'] ?? '';
  static final String scopes = dotenv.env['SPOTIFY_SCOPES'] ?? '';

  static Future<bool> authenticate() async {
    try {
      // Build the authorization URL
      final Uri authUrl = Uri(
        scheme: 'https',
        host: 'accounts.spotify.com',
        path: 'authorize',
        queryParameters: {
          'client_id': clientId,
          'response_type': 'code',
          'redirect_uri': redirectUri,
          'scope': scopes,
        },
      );

      final url = authUrl.toString();
      // Open the Spotify login page
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: redirectUri.split(':').first,
      );

      // Extract the authorization code from the callback URL
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) return false;

      // Exchange the authorization code for tokens
      return await _exchangeCodeForTokens(code);
    } catch (e) {
      print('Error during Spotify login: $e');
      return false;
    }
  }

  static Future<bool> _exchangeCodeForTokens(String code) async {
    try {
      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await AuthService.setTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresIn: data['expires_in'],
        );
        return true;
      }
      print('Failed to exchange code: ${response.body}');
      return false;
    } catch (e) {
      print('Error exchanging code for tokens: $e');
      return false;
    }
  }

  static Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await AuthService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {
          'Authorization':
              'Basic ' + base64Encode(utf8.encode('$clientId:$clientSecret')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await AuthService.setTokens(
          accessToken: data['access_token'],
          refreshToken: refreshToken, // Reuse the same refresh token
          expiresIn: data['expires_in'],
        );
        return true;
      }
      print('Failed to refresh access token: ${response.body}');
      return false;
    } catch (e) {
      print('Error refreshing access token: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> fetchUserProfile() async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse(accountUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to fetch user profile: ${response.body}');
      return null;
    }
  }

  static Future<List<dynamic>?> fetchTopArtists() async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/me/top/artists?time_range=long_term&limit=10'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      print('Failed to fetch top artists: ${response.body}');
      return null;
    }
  }

  static Future<List<dynamic>?> fetchTopTracks() async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse(
          'https://api.spotify.com/v1/me/top/tracks?time_range=long_term&limit=10'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      print('Failed to fetch top tracks: ${response.body}');
      return null;
    }
  }

  static Future<int?> fetchFollowingData() async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me/following?type=artist'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['artists']['total']; // Extract 'total' from the response
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }

  static Future<int?> fetchPlaylistCount(String userId) async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/users/${userId}/playlists'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'].length; // Extract 'total' from the response
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchArtistDetails(
      String artistId) async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/${artistId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }

  static Future<List<dynamic>?> fetchArtistDiscography(String artistId) async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/${artistId}/albums'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'];
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }

  static Future<List<dynamic>?> fetchArtistTopTracks(String artistId) async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/artists/${artistId}/top-tracks'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['tracks'];
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchAlbumDetails(String albumId) async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/albums/${albumId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchTrackDetails(String trackId) async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/${trackId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> fetchTrackAnalysis(
      String trackId) async {
    final accessToken = await AuthService.getAccessToken();
    if (accessToken == null) return null;

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/audio-analysis/${trackId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      print('Failed to fetch following data: ${response.body}');
      return null;
    }
  }
}
