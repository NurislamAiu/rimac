import 'package:flutter/material.dart';
import '../../data/repositories/artifact_repository.dart';
import '../../domain/entities/artifact.dart';

enum ArtifactState { initial, loading, loaded, error }

class ArtifactProvider extends ChangeNotifier {
  final _artifactRepository = ArtifactRepository();

  List<Artifact> _artifacts = [];
  List<Artifact> get artifacts => _artifacts;

  ArtifactState _state = ArtifactState.initial;
  ArtifactState get state => _state;

  Artifact? _selectedArtifact;
  Artifact? get selectedArtifact => _selectedArtifact;

  ArtifactProvider() {
    fetchArtifacts();
  }

  Future<void> fetchArtifacts() async {
    _state = ArtifactState.loading;
    notifyListeners();

    try {
      _artifacts = await _artifactRepository.getArtifacts();
      // Select the first artifact by default
      if (_artifacts.isNotEmpty) {
        _selectedArtifact = _artifacts.first;
      }
      _state = ArtifactState.loaded;
    } catch (e) {
      _state = ArtifactState.error;
    }
    notifyListeners();
  }

  void selectArtifact(Artifact artifact) {
    _selectedArtifact = artifact;
    notifyListeners();
  }
}
