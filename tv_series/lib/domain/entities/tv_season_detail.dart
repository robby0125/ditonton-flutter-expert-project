import 'tv_episode.dart';
import 'package:equatable/equatable.dart';

class TvSeasonDetail extends Equatable {
  const TvSeasonDetail({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.tvEpisodeId,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String id;
  final DateTime? airDate;
  final List<TvEpisode> episodes;
  final String name;
  final String overview;
  final int tvEpisodeId;
  final String? posterPath;
  final int seasonNumber;

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        tvEpisodeId,
        posterPath,
        seasonNumber,
      ];
}
