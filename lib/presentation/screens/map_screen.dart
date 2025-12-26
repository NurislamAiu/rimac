import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/artifact.dart';
import '../widgets/glowing_marker.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});

  final List<Artifact> _mockArtifacts = [
    Artifact(
      id: '1',
      name: 'Tutankhamun Mask',
      lat: 29.9792,
      lng: 31.1342,
      period: 'Ancient Egypt',
      popularity: 95,
    ),
    Artifact(
      id: '2',
      name: 'Terracotta Army',
      lat: 34.3848,
      lng: 109.2734,
      period: 'Ancient China',
      popularity: 92,
    ),
    Artifact(
      id: '3',
      name: 'Machu Picchu',
      lat: -13.1631,
      lng: -72.5450,
      period: 'Inca Civilization',
      popularity: 88,
    ),
    Artifact(
      id: '4',
      name: 'Pompeii Ruins',
      lat: 40.7460,
      lng: 14.4989,
      period: 'Roman Empire',
      popularity: 80,
    ),
    Artifact(
      id: '5',
      name: 'Stonehenge',
      lat: 51.1789,
      lng: -1.8262,
      period: 'Neolithic',
      popularity: 85,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(20, 0),
              initialZoom: 2.2,
              minZoom: 2,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.archaeology.map',
              ),
              MarkerLayer(
                markers: _mockArtifacts.map((a) {
                  final size = _markerSize(a.popularity);

                  return Marker(
                    point: LatLng(a.lat, a.lng),
                    width: size * 3,
                    height: size * 3,
                    child: GestureDetector(
                      onTap: () => _openArtifact(context, a),
                      child: Center(
                        child: GlowingMarker(size: size),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // 🔝 Glass Top Bar
          Positioned(
            top: 32,
            left: 20,
            right: 20,
            child: _GlassTopBar(),
          ),

          // 🧭 Minimal Legend
          Positioned(
            bottom: 24,
            left: 20,
            child: _MinimalLegend(),
          ),
        ],
      ),
    );
  }

  double _markerSize(int popularity) {
    if (popularity >= 90) return 12;
    if (popularity >= 75) return 10;
    if (popularity >= 50) return 8;
    return 6;
  }

  void _openArtifact(BuildContext context, Artifact artifact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artifact.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              artifact.period,
              style: const TextStyle(color: Colors.redAccent),
            ),
            const SizedBox(height: 12),
            Text(
              'Popularity: ${artifact.popularity}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}


class _GlassTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.45),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: const [
          Icon(Icons.public, color: Colors.redAccent),
          SizedBox(width: 10),
          Text(
            'Archaeology Map',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Spacer(),
          Icon(Icons.search, size: 20),
          SizedBox(width: 14),
          Icon(Icons.tune, size: 20),
        ],
      ),
    );
  }
}

class _MinimalLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: const [
          _LegendDot(size: 12),
          SizedBox(width: 6),
          Text('Major'),
          SizedBox(width: 12),
          _LegendDot(size: 8),
          SizedBox(width: 6),
          Text('Medium'),
          SizedBox(width: 12),
          _LegendDot(size: 6),
          SizedBox(width: 6),
          Text('Minor'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final double size;
  const _LegendDot({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
    );
  }
}


