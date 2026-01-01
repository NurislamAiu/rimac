import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/artifact.dart';
import '../providers/artifact_provider.dart';
import '../widgets/artifact_card.dart';
import '../widgets/glowing_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  late final MapController _mapController;
  late final PageController _pageController;

  static const double _carouselHeight = 220.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pageController = PageController(viewportFraction: 0.85);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ArtifactProvider>();
      provider.addListener(_onProviderInit);
    });
  }

  void _onProviderInit() {
    final provider = context.read<ArtifactProvider>();
    if (provider.state == ArtifactState.loaded && provider.artifacts.isNotEmpty) {
      _animatedMapMove(provider.artifacts.first.location, 10.0);
      provider.removeListener(_onProviderInit);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    final latTween = Tween<double>(begin: _mapController.camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: _mapController.camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: _mapController.camera.zoom, end: destZoom);

    final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    final animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      _mapController.move(LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)), zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  void _onPageChanged(int index, ArtifactProvider provider) {
    final artifact = provider.artifacts[index];
    provider.selectArtifact(artifact);
    _animatedMapMove(artifact.location, 12.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Карта сокровищ'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.7),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Consumer<ArtifactProvider>(
        builder: (context, provider, child) {
          if (provider.state == ArtifactState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.state == ArtifactState.error) {
            return const Center(child: Text('Не удалось загрузить данные'));
          }
          return Stack(
            children: [
              _buildMap(provider.artifacts, provider.selectedArtifact, isDarkMode),
              _buildArtifactCarousel(provider),
              _buildZoomButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMap(List<Artifact> artifacts, Artifact? selectedArtifact, bool isDarkMode) {
    final mapStyleUrl = isDarkMode
        ? 'https://{s}.basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';
    
    final realArtifacts = artifacts.where((a) => !a.isAiGenerated).toList();
    final aiArtifacts = artifacts.where((a) => a.isAiGenerated).toList();

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: artifacts.first.location,
        initialZoom: 5.0,
      ),
      children: [
        TileLayer(
          urlTemplate: mapStyleUrl,
          subdomains: const ['a', 'b', 'c', 'd'],
        ),
        CircleLayer(
          circles: aiArtifacts.map((artifact) {
            return CircleMarker(
              point: artifact.location,
              radius: artifact.searchRadius ?? 1000,
              useRadiusInMeter: true,
              color: Colors.green.withOpacity(0.2),
              borderColor: Colors.green,
              borderStrokeWidth: 2,
            );
          }).toList(),
        ),
        MarkerLayer(
          markers: artifacts.map((artifact) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: artifact.location,
              child: GestureDetector(
                onTap: () {
                  final index = artifacts.indexWhere((a) => a.id == artifact.id);
                  if (index != -1) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: GlowingMarker(
                  isSelected: artifact.id == selectedArtifact?.id,
                  isAiGenerated: artifact.isAiGenerated,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildArtifactCarousel(ArtifactProvider provider) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: _carouselHeight,
        child: PageView.builder(
          controller: _pageController,
          itemCount: provider.artifacts.length,
          onPageChanged: (index) => _onPageChanged(index, provider),
          itemBuilder: (context, index) {
            final artifact = provider.artifacts[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
              child: ArtifactCard(artifact: artifact),
            );
          },
        ),
      ),
    );
  }

  Widget _buildZoomButtons() {
    return Positioned(
      bottom: _carouselHeight + 16,
      right: 16,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: "zoom_in_button",
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              _animatedMapMove(_mapController.camera.center, currentZoom + 1);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: "zoom_out_button",
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              _animatedMapMove(_mapController.camera.center, currentZoom - 1);
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
