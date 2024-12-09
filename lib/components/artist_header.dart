import 'package:flutter/material.dart';

class ArtistHeader extends StatelessWidget {
  final String imageUrl;
  final String name;

  const ArtistHeader({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
            radius: 200,
          ),
        ),
        SizedBox(height: 32),
        Center(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
