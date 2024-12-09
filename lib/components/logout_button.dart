import 'package:flutter/material.dart';
import 'package:spotify/theme/custom_color_scheme.dart';
import '../services/auth_service.dart';
import '../screens/login_page.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: customColorScheme.surface,
            foregroundColor: customColorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
              side: BorderSide(
                color: customColorScheme.onSurface,
                width: 1,
              ),
            ),
          ),
          onPressed: () async {
            await AuthService.clearTokens();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          },
          child: Text('logout'.toUpperCase()),
        ),
      ),
    );
  }
}
