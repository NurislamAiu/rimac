import 'package:flutter/material.dart';

class ArtifactCard extends StatelessWidget {
  const ArtifactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('Artifact Card'),
      ),
    );
  }
}
