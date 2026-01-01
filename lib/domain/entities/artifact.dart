import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

@immutable
class Artifact {
  const Artifact({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.discoveryDate,
    required this.era,
    required this.materials,
    required this.museum,
    this.isAiGenerated = false,
    this.searchRadius, // in meters
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final LatLng location;
  final DateTime discoveryDate;
  final String era;
  final List<String> materials;
  final String museum;
  final bool isAiGenerated;
  final double? searchRadius;
}
