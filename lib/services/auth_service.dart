import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _accessTokenExpiryKey = 'access_token_expiry';

  static final String clientId = dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  static final String clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';
  static final String tokenEndpoint = dotenv.env['SPOTIFY_TOKEN_URL'] ?? '';

  static Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) async {
    final expiryTime =
        DateTime.now().add(Duration(seconds: expiresIn)).toIso8601String();
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    await _storage.write(key: _accessTokenExpiryKey, value: expiryTime);
  }

  static Future<String?> getAccessToken() async {
    final expiry = await _storage.read(key: _accessTokenExpiryKey);
    if (expiry != null) {
      final expiryTime = DateTime.parse(expiry);
      if (DateTime.now().isAfter(expiryTime)) {
        final success = await _refreshAccessToken();
        if (!success) {
          await clearTokens();
          return null;
        }
      }
    }
    return await _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<bool> _refreshAccessToken() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    if (refreshToken == null) return false;

    final response = await http.post(
      Uri.parse(tokenEndpoint),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await setTokens(
        accessToken: data['access_token'],
        refreshToken: refreshToken,
        expiresIn: data['expires_in'],
      );
      return true;
    }

    return false;
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _accessTokenExpiryKey);
  }
}
