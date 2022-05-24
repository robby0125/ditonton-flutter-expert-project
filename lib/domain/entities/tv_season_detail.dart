import 'package:ditonton/domain/entities/tv_episode.dart';
import 'package:equatable/equatable.dart';

class TvSeasonDetail extends Equatable {
  TvSeasonDetail({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.tvEpisodeId,
    required this.posterPath,
    required this.seasonNumber,
  });

  String id;
  DateTime airDate;
  List<TvEpisode> episodes;
  String name;
  String overview;
  int tvEpisodeId;
  String? posterPath;
  int seasonNumber;

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
