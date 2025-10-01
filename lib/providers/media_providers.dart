import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_service.dart';
import '../models/channel.dart';
import '../models/movie.dart';
import '../models/series.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final channelsProvider = FutureProvider<List<Channel>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  final list = await api.fetchJsonList('channels', assetFallback: 'assets/data/channels.json');
  return list.map((e) => Channel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
});

final moviesProvider = FutureProvider<List<Movie>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  final list = await api.fetchJsonList('movies', assetFallback: 'assets/data/movies.json');
  return list.map((e) => Movie.fromJson(Map<String, dynamic>.from(e as Map))).toList();
});

final seriesProvider = FutureProvider<List<Series>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  final list = await api.fetchJsonList('series', assetFallback: 'assets/data/series.json');
  return list.map((e) => Series.fromJson(Map<String, dynamic>.from(e as Map))).toList();
});
