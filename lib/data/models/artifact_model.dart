import '../../domain/entities/artifact.dart';

class ArtifactModel extends Artifact {
  const ArtifactModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.location,
    required super.discoveryDate,
    required super.era,
    required super.materials,
    required super.museum,
    super.isAiGenerated,
    super.searchRadius,
  });
}
