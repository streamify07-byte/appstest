import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/series.dart';
import '../../../providers/media_providers.dart';

class SeriesScreen extends ConsumerWidget {
  const SeriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(seriesProvider);

    return seriesAsync.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final s = items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ExpansionTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: s.posterUrl,
                  width: 48,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(s.title),
              subtitle: Text(s.overview),
              children: [
                ...s.seasons.map((season) {
                  return ExpansionTile(
                    title: Text('Season ${season.seasonNumber}'),
                    children: [
                      ...season.episodes.map((ep) {
                        return ListTile(
                          title: Text('E${ep.episodeNumber}: ${ep.title}'),
                          subtitle: ep.durationMinutes != null ? Text('Duration: ${ep.durationMinutes} min') : null,
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Failed to load series')),
    );
  }
}
