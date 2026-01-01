import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/artifact.dart';

class ArtifactDetailScreen extends StatelessWidget {
  const ArtifactDetailScreen({super.key, required this.artifact});

  final Artifact artifact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
        title: Text(
          artifact.name,
          textAlign: TextAlign.center,
          style: const TextStyle(shadows: [
            Shadow(color: Colors.black87, blurRadius: 10, offset: Offset(2, 2))
          ]),
        ),
        background: Hero(
          tag: 'artifact_image_${artifact.id}',
          child: Image.network(
            artifact.imageUrl,
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            if (artifact.isAiGenerated) _buildAiDisclaimer(context),
            _InfoRow(
              icon: Icons.hourglass_bottom,
              label: artifact.isAiGenerated ? 'Прогнозируемая эпоха' : 'Эпоха',
              value: artifact.era,
            ),
            if (artifact.isAiGenerated)
              _InfoRow(
                icon: Icons.radar,
                label: 'Радиус поиска',
                value: '${(artifact.searchRadius! / 1000).toStringAsFixed(1)} км',
              )
            else
              _InfoRow(
                icon: Icons.calendar_today,
                label: 'Дата обнаружения',
                value: DateFormat.yMMMMd('ru').format(artifact.discoveryDate),
              ),
            _InfoRow(
              icon: Icons.museum,
              label: artifact.isAiGenerated ? 'Статус' : 'Место хранения',
              value: artifact.museum,
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: artifact.isAiGenerated ? 'Предполагаемые материалы' : 'Материалы'),
            _buildMaterialChips(context),
            const SizedBox(height: 24),
            _SectionTitle(title: artifact.isAiGenerated ? 'Обоснование прогноза' : 'Описание'),
            Text(
              artifact.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(height: 1.6, fontSize: 16),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAiDisclaimer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          const Icon(Icons.computer, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Это прогнозная зона, сгенерированная ИИ. Информация не является подтвержденной.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialChips(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: artifact.materials.map((material) {
        return Chip(
          label: Text(material),
          backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.2),
          side: BorderSide.none,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.secondary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodyMedium),
                const SizedBox(height: 2),
                Text(value, style: textTheme.headlineSmall?.copyWith(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
