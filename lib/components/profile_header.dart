import 'package:flutter/material.dart';
import 'package:spotify/theme/custom_color_scheme.dart';

class ProfileHeader extends StatelessWidget {
  final String? imageUrl;
  final String displayName;
  final String accountType;

  const ProfileHeader({
    super.key,
    required this.imageUrl,
    required this.displayName,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            radius: 125,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            displayName,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            'You are a $accountType subscriber',
            style: TextStyle(
              fontSize: 16,
              color: customColorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
